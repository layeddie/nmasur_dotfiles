# Jellyfin is a self-hosted video streaming service. This means I can play my
# server's videos from a webpage, mobile app, or TV client.

{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (config.nmasur.settings) hostnames;
  cfg = config.nmasur.presets.services.jellyfin;
in
{

  options.nmasur.presets.services.jellyfin.enable = lib.mkEnableOption "Jellyfin video streaming";

  config = lib.mkIf cfg.enable {

    services.jellyfin.group = lib.mkIf config.nmasur.profiles.shared-media.enable "shared";
    users.users.jellyfin = {
      isSystemUser = true;
    };

    nmasur.presets.services.caddy.routes = [
      # Prevent public access to Prometheus metrics.
      {
        match = [
          {
            host = [ hostnames.stream ];
            path = [ "/metrics*" ];
          }
        ];
        handle = [
          {
            handler = "static_response";
            status_code = "403";
          }
        ];
      }
      # Allow access to normal route.
      {
        match = [ { host = [ hostnames.stream ]; } ];
        handle = [
          {
            handler = "reverse_proxy";
            upstreams = [ { dial = "localhost:8096"; } ];
          }
        ];
      }
    ];

    # Configure Cloudflare DNS to point to this machine
    services.cloudflare-dyndns.domains = [ hostnames.stream ];

    # Create videos directory, allow anyone in Jellyfin group to manage it
    systemd.tmpfiles.rules = [
      "d /var/lib/jellyfin 0775 jellyfin shared"
      "d /var/lib/jellyfin/library 0775 jellyfin shared"
    ];

    # Enable VA-API for hardware transcoding
    hardware.graphics = {
      enable = true;
      extraPackages = [ pkgs.libva ];
    };
    environment.systemPackages = [ pkgs.libva-utils ];
    environment.variables = {
      # VAAPI and VDPAU config for accelerated video.
      # See https://wiki.archlinux.org/index.php/Hardware_video_acceleration
      "VDPAU_DRIVER" = "radeonsi";
      "LIBVA_DRIVER_NAME" = "radeonsi";
    };
    users.users.jellyfin.extraGroups = [
      "render"
      "video"
    ]; # Access to /dev/dri

    # Fix issue where Jellyfin-created directories don't allow access for media group
    systemd.services.jellyfin.serviceConfig.UMask = lib.mkForce "0007";

    # Requires MetricsEnable is true in /var/lib/jellyfin/config/system.xml
    nmasur.presets.services.prometheus-exporters.scrapeTargets = [ "127.0.0.1:8096" ];
  };
}
