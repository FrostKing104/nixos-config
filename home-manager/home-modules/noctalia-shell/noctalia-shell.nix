{ pkgs, inputs, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia-shell = {
    enable = true;

    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        tailscale = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        "assistant-panel" = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        "mini-docker" = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
    };
    pluginSettings = {
      tailscale = {
        showIpAddress = true;
        showPeerCount = false;
        refreshInterval = 5000;
        compactMode = false;
        defaultPeerAction = "copy-id";
        hideDisconnected = false;
        pingCount = 5;
        terminalCommand = "kitty";
      };
      
      "assistant-panel" = {
        showIcon = true;
        ai = {
          provider = "google";
          model = "gemini-2.5-flash";
	  systemPrompt = ''
            You are a smart assistant integrated into a Linux desktop shell.

            USER PROFILE:
            - **Identity:** Computer Science student at GSU Perimeter College (Newton Campus).
            - **Background:** Self-taught/homeschooled; prefers direct technical answers without "hand-holding."
            - **Location:** Loganville, GA.

            SYSTEM CONFIGURATION:
            - **OS:** NixOS 25.11 (Xantusia) | Kernel: Linux 6.12.
            - **Window Manager:** Hyprland 0.52.1 (Wayland). *Note: KDE Plasma is installed but strictly unused.*
            - **Hardware Specs:**
              - **CPU:** AMD Ryzen 5 3600 (6-core/12-thread @ 3.6GHz).
              - **GPU:** AMD Radeon RX 580 2048SP (Discrete).
              - **RAM:** 16GB (2x8GB, ddr4).
              - **Display:** 1920x1080 @ 60Hz.
	      - **Keyboard:** Custome Corne 4.1, managed with Vial

            GUIDELINES:
            1. **NixOS Context:** Assume a declarative system (configuration.nix/home-manager) for all software advice.
            2. **Silence on Distro:** Do not explicitly mention "As a NixOS user" unless the distinction is critical for the specific error being discussed.
            3. **Brevity:** Keep responses concise and optimized for a terminal/coding workflow.
            4. **Hyprland:** Assume standard Hyprland config files (.conf) for UI adjustments.
          '';
          apiKeys = {
            google = "";
          };
        };
      };

      "mini-docker" = {
        socketPath = "/var/run/docker.sock";
        refreshInterval = 2000;
      };
    };

    settings = {
      settingsVersion = 46; 

      appLauncher = {
        autoPasteClipboard = false;
        clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
        clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
        clipboardWrapText = true;
        customLaunchPrefix = "";
        customLaunchPrefixEnabled = false;
        enableClipPreview = true;
        enableClipboardHistory = false;
        enableSettingsSearch = true;
        iconMode = "tabler";
        ignoreMouseInput = false;
        pinnedApps = [];
        position = "center";
        screenshotAnnotationTool = "";
        showCategories = true;
        showIconBackground = false;
        sortByMostUsed = true;
        terminalCommand = "kitty -e";
        useApp2Unit = false;
        viewMode = "list";
      };

      audio = {
        cavaFrameRate = 30;
        mprisBlacklist = [];
        preferredPlayer = "Firefox";
        visualizerType = "linear";
        volumeFeedback = false;
        volumeOverdrive = false;
        volumeStep = 5;
      };

      bar = {
        backgroundOpacity = 0.93;
        barType = "simple";
        capsuleOpacity = 1;
        density = "default";
        exclusive = true;
        floating = false;
        frameRadius = 12;
        frameThickness = 8;
        hideOnOverview = false;
        marginHorizontal = 5;
        marginVertical = 5;
        monitors = [];
        outerCorners = false;
        position = "top";
        screenOverrides = [];
        showCapsule = false;
        showOutline = false;
        useSeparateOpacity = false;

        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
              colorizeDistroLogo = true;
              colorizeSystemIcon = "primary";
              enableColorization = true;
            }
            {
              id = "plugin:assistant-panel";
            }
            {
              compactMode = false;
              diskPath = "/";
              id = "SystemMonitor";
              showCpuTemp = true;
              showCpuUsage = true;
              showDiskUsage = false;
              showGpuTemp = false;
              showLoadAverage = false;
              showMemoryAsPercent = true;
              showMemoryUsage = true;
              showNetworkStats = false;
              showSwapUsage = false;
              useMonospaceFont = true;
              colorizeIcons = true;
              usePrimaryColor = true;
            }
            {
              id = "ActiveWindow";
            }
          ];
          center = [
            {
              characterCount = 2;
              colorizeIcons = true;
              emptyColor = "secondary";
              enableScrollWheel = true;
              focusedColor = "primary";
              followFocusedScreen = false;
              groupedBorderOpacity = 1;
              hideUnoccupied = false;
              iconScale = 0.8;
              id = "Workspace";
              labelMode = "name";
              occupiedColor = "secondary";
              reverseScroll = false;
              showApplications = false;
              showBadge = true;
              showLabelsOnlyWhenOccupied = true;
              unfocusedIconsOpacity = 1;
            }
            {
              compactMode = false;
              compactShowAlbumArt = true;
              compactShowVisualizer = false;
              hideMode = "hidden";
              hideWhenIdle = false;
              id = "MediaMini";
              maxWidth = 350;
              panelShowAlbumArt = true;
              panelShowVisualizer = true;
              scrollingMode = "hover";
              showAlbumArt = true;
              showArtistFirst = true;
              showControls = true;
              showVisualizer = true;
              visualizerType = "mirrored";
            }
            {
              displayMode = "onhover";
              id = "Volume";
              middleClickCommand = "pwvucontrol || pavucontrol";
            }
          ];
          right = [
            {
              blacklist = [];
              colorizeIcons = true;
              drawerEnabled = false;
              hidePassive = false;
              id = "Tray";
              pinned = [];
            }
            {
              id = "plugin:mini-docker";
            }
            {
              displayMode = "onhover";
              id = "Bluetooth";
            }
	    {
              displayMode = "onhover";
              id = "Network";
            }
            {
              hideWhenZero = true;
              hideWhenZeroUnread = false;
              id = "NotificationHistory";
              showUnreadBadge = true;
              unreadBadgeColor = "primary";
            }
            {
              displayMode = "alwaysShow";
              id = "Volume";
              middleClickCommand = "pwvucontrol || pavucontrol";
            }
            {
	      id = "plugin:tailscale";
            }
            {
              customFont = "";
              formatHorizontal = "h:mm AP — ddd, MMM";
              formatVertical = "h:mm AP ddd, MMM";
              id = "Clock";
              tooltipFormat = "HH:mm ddd, MMM dd";
              useCustomFont = false;
              usePrimaryColor = true;
            }
          ];
        };
      };
      brightness = {
        brightnessStep = 5;
	enableDdcSupport = true;
	enforceMinimum = false;
      };

      colorSchemes = {
        darkMode = true;
        generationMethod = "tonal-spot";
        manualSunrise = "06:30";
        manualSunset = "18:30";
        monitorForColors = "";
        predefinedScheme = "Catppuccin";
        schedulingMode = "off";
        useWallpaperColors = false;
      };

      controlCenter = {
        cards = [
          { enabled = true; id = "profile-card"; }
          { enabled = true; id = "shortcuts-card"; }
          { enabled = true; id = "audio-card"; }
          { enabled = true; id = "weather-card"; }
          { enabled = true; id = "media-sysmon-card"; }
        ];
        diskPath = "/";
        position = "close_to_bar_button";
        shortcuts = {
          left = [
            { id = "Network"; }
            { id = "Bluetooth"; }
            { id = "NoctaliaPerformance"; }
          ];
          right = [
            { id = "Notifications"; }
            { id = "WallpaperSelector"; }
          ];
        };
      };

      desktopWidgets = {
        enabled = false;
        gridSnap = false;
        monitorWidgets = [];
      };

      dock = {
        animationSpeed = 1;
        backgroundOpacity = 1;
        colorizeIcons = false;
        deadOpacity = 0.6;
        displayMode = "auto_hide";
        enabled = false;
        floatingRatio = 1;
        inactiveIndicators = false;
        monitors = [];
        onlySameOutput = true;
        pinnedApps = [];
        pinnedStatic = false;
        position = "bottom";
        size = 1;
      };

      general = {
        allowPanelsOnScreenWithoutBar = true;
        allowPasswordWithFprintd = false;
        animationDisabled = false;
        animationSpeed = 1;
        autoStartAuth = false;
        avatarImage = "/home/anklus/Pictures/profilePicture";
        boxRadiusRatio = 1;
        compactLockScreen = true;
        dimmerOpacity = 0.25;
        enableLockScreenCountdown = true;
        enableShadows = false;
        forceBlackScreenCorners = false;
        iRadiusRatio = 1;
        language = "";
        lockOnSuspend = true;
        lockScreenCountdownDuration = 10000;
        radiusRatio = 0.25;
        scaleRatio = 1;
        screenRadiusRatio = 0.25;
        shadowDirection = "bottom_right";
        shadowOffsetX = 2;
        shadowOffsetY = 3;
        showChangelogOnStartup = true;
        showHibernateOnLockScreen = false;
        showScreenCorners = false;
        showSessionButtonsOnLockScreen = true;
        telemetryEnabled = false;
      };

      hooks = {
	enabled = true;
        darkModeChange = "";
        performanceModeDisabled = "";
        performanceModeEnabled = "";
        screenLock = "";
        screenUnlock = "notif-send \"Welcome back, sir.\"";
        session = "";
        startup = "";
        wallpaperChange = "";
      };

      location = {
        analogClockInCalendar = false;
        firstDayOfWeek = -1;
        hideWeatherCityName = false;
        hideWeatherTimezone = false;
        name = "Loganville Georgia";
        showCalendarEvents = true;
        showCalendarWeather = true;
        showWeekNumberInCalendar = false;
        use12hourFormat = true;
        useFahrenheit = true;
        weatherEnabled = true;
        weatherShowEffects = true;
      };

      network = {
        bluetoothDetailsViewMode = "grid";
        bluetoothHideUnnamedDevices = false;
        bluetoothRssiPollIntervalMs = 10000;
        bluetoothRssiPollingEnabled = false;
        wifiDetailsViewMode = "grid";
        wifiEnabled = true;
      };

      nightLight = {
        autoSchedule = true;
        dayTemp = "6500";
        enabled = false;
        forced = false;
        manualSunrise = "06:30";
        manualSunset = "18:30";
        nightTemp = "4000";
      };

      notifications = {
        backgroundOpacity = 1;
        criticalUrgencyDuration = 15;
        density = "default";
        enableBatteryToast = true;
        enableKeyboardLayoutToast = true;
        enableMediaToast = false;
        enabled = true;
        location = "top_right";
        lowUrgencyDuration = 3;
        monitors = [];
        normalUrgencyDuration = 8;
        overlayLayer = true;
        respectExpireTimeout = false;
        saveToHistory = {
          critical = true;
          low = true;
          normal = true;
        };
        sounds = {
          criticalSoundFile = "";
          enabled = true;
          excludedApps = "discord,firefox,chrome,chromium,edge";
          lowSoundFile = "";
          normalSoundFile = "";
          separateSounds = false;
          volume = 0.5;
        };
      };

      osd = {
        autoHideMs = 2000;
        backgroundOpacity = 1;
        enabled = true;
        enabledTypes = [ 0 1 2 ];
        location = "top_right";
        monitors = [];
        overlayLayer = true;
      };

      sessionMenu = {
        countdownDuration = 10000;
        enableCountdown = true;
        largeButtonsLayout = "grid";
        largeButtonsStyle = false;
        position = "center";
        powerOptions = [
          { action = "lock"; enabled = true; keybind = "1"; }
          { action = "suspend"; enabled = true; keybind = "2"; }
          { action = "hibernate"; enabled = true; keybind = "3"; }
          { action = "reboot"; enabled = true; keybind = "4"; }
          { action = "logout"; enabled = true; keybind = "5"; }
          { action = "shutdown"; enabled = true; keybind = "6"; }
        ];
        showHeader = true;
        showNumberLabels = true;
      };

      systemMonitor = {
        cpuCriticalThreshold = 90;
        cpuPollingInterval = 3000;
        cpuWarningThreshold = 80;
        criticalColor = "";
        diskAvailCriticalThreshold = 10;
        diskAvailWarningThreshold = 20;
        diskCriticalThreshold = 90;
        diskPollingInterval = 3000;
        diskWarningThreshold = 80;
        enableDgpuMonitoring = false;
        externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
        gpuCriticalThreshold = 90;
        gpuPollingInterval = 3000;
        gpuWarningThreshold = 80;
        loadAvgPollingInterval = 3000;
        memCriticalThreshold = 90;
        memPollingInterval = 3000;
        memWarningThreshold = 80;
        networkPollingInterval = 3000;
        swapCriticalThreshold = 90;
        swapWarningThreshold = 80;
        tempCriticalThreshold = 90;
        tempPollingInterval = 3000;
        tempWarningThreshold = 80;
        useCustomColors = false;
        warningColor = "";
      };

      templates = {
        activeTemplates = [];
        enableUserTheming = false;
      };

      ui = {
        bluetoothDetailsViewMode = "grid";
        bluetoothHideUnnamedDevices = false;
        boxBorderEnabled = false;
        fontDefault = "JetBrains Mono";
        fontDefaultScale = 1;
        fontFixed = "JetBrains Mono";
        fontFixedScale = 1;
        networkPanelView = "wifi";
        panelBackgroundOpacity = 1;
        panelsAttachedToBar = true;
        settingsPanelMode = "centered";
        tooltipsEnabled = true;
        wifiDetailsViewMode = "grid";
      };

      wallpaper = {
        automationEnabled = true;
        directory = "/home/anklus/Pictures/wallpapers/";
        enableMultiMonitorDirectories = false;
        enabled = true;
        favorites = [];
        fillColor = "#000000";
        fillMode = "crop";
        hideWallpaperFilenames = false;
        monitorDirectories = [];
        overviewEnabled = false;
        panelPosition = "follow_bar";
        randomIntervalSec = 300;
        setWallpaperOnAllMonitors = true;
        showHiddenFiles = false;
        solidColor = "#1a1a2e";
        transitionDuration = 1500;
        transitionEdgeSmoothness = 0.05;
        transitionType = "random";
        useSolidColor = false;
        useWallhaven = false;
        viewMode = "recursive";
        wallhavenApiKey = "";
        wallhavenCategories = "111";
        wallhavenOrder = "desc";
        wallhavenPurity = "100";
        wallhavenRatios = "";
        wallhavenResolutionHeight = "";
        wallhavenResolutionMode = "atleast";
        wallhavenResolutionWidth = "";
        wallhavenSorting = "relevance";
        wallpaperChangeMode = "random";
      };
    };
  };
}
