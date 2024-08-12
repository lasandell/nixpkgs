{ config, lib, pkgs, ... }:
with lib;
let 
  cfg = config.services.sdrplayApi;
in
{
  options.services.sdrplayApi = {
    enable = mkOption {
      default = false;
      example = true;
      description = ''
        Whether to enable the SDRplay API service and udev rules.

        ::: {.note}
        See the `services.sdrplayApi.soapySdrPlugin.enable` option for information on enabling the
        SoapySDR plugin for applications that require it.
        :::
      '';
      type = lib.types.bool;
    };

    soapySdrPlugin = {
      enable = mkOption {
        default = cfg.enable;
        defaultText = literalExpression "config.services.sdrplayApi.enable";
        example = true;
        description = ''
          Whether to enable the SDRplay plugin for SoapySDR.

          If enabled, the `SOAPY_SDR_PLUGIN_PATH` environment variable will be set to the path of the
          SoapySDR plugin, allowing applications like Gqrx and CubicSDR to find it. You will need to
          to log out of your current session for the new environment variable to take effect.

          ::: {.note}
          Previously it was suggested to create an overlay containing
          `soapysdr-with-plugins = super.soapysdr.override { extraPackages = [ super.soapysdrplay ]; }`
          to enable the plugin. However, this causes packages that depend on SoapySDR to be frequently
          rebuilt, so it is no longer recommended.
          :::
        '';
        type = lib.types.bool;
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      systemd.services.sdrplayApi = {
        description = "SDRplay API Service";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.sdrplay}/bin/sdrplay_apiService";
          DynamicUser = true;
          Restart = "on-failure";
          RestartSec = "1s";
        };
      };
  
      services.udev.packages = [ pkgs.sdrplay ];
    })

    (mkIf cfg.soapySdrPlugin.enable {
      environment.variables = {
        SOAPY_SDR_PLUGIN_PATH = "${pkgs.soapysdrplay}/${pkgs.soapysdr.passthru.searchPath}";
      };
    })
  ];
}
