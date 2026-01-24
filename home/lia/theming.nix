{ config, pkgs, ... }:

# Rosé Pine theming for CLI tools
# This complements gtk.nix which handles GUI theming

let
  # Rosé Pine color palette
  colors = {
    base = "#191724";
    surface = "#1f1d2e";
    overlay = "#26233a";
    muted = "#6e6a86";
    subtle = "#908caa";
    text = "#e0def4";
    love = "#eb6f92";
    gold = "#f6c177";
    rose = "#ebbcba";
    pine = "#31748f";
    foam = "#9ccfd8";
    iris = "#c4a7e7";
    highlightLow = "#21202e";
    highlightMed = "#403d52";
    highlightHigh = "#524f67";
  };
in
{
  # bat - cat replacement with syntax highlighting
  programs.bat = {
    enable = true;
    config = {
      theme = "rose-pine";
      style = "numbers,changes,header";
      italic-text = "always";
    };
    themes = {
      rose-pine = {
        src = pkgs.fetchFromGitHub {
          owner = "rose-pine";
          repo = "tm-theme";
          rev = "c4235f9a65fd180ac0f5e4396e3a86e21a0884ec";
          sha256 = "sha256-jji8WOKDkzAq8K+uSZAziMULI8Kh7e96cBRimGvIYKY=";
        };
        file = "dist/themes/rose-pine.tmTheme";
      };
    };
  };

  # btop - system monitor
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "rose-pine";
      theme_background = true;
      truecolor = true;
      force_tty = false;
      vim_keys = true;
      rounded_corners = true;
      graph_symbol = "braille";
      shown_boxes = "cpu mem net proc";
      update_ms = 1000;
      proc_tree = true;
    };
  };

  # btop Rosé Pine theme
  xdg.configFile."btop/themes/rose-pine.theme".text = ''
    # Rosé Pine theme for btop

    # Main background
    theme[main_bg]="${colors.base}"

    # Main text color
    theme[main_fg]="${colors.text}"

    # Title color for boxes
    theme[title]="${colors.text}"

    # Highlight color for keyboard shortcuts
    theme[hi_fg]="${colors.iris}"

    # Background color of selected items
    theme[selected_bg]="${colors.highlightMed}"

    # Foreground color of selected items
    theme[selected_fg]="${colors.text}"

    # Color of inactive/disabled text
    theme[inactive_fg]="${colors.muted}"

    # Color of text appearing on top of graphs
    theme[graph_text]="${colors.subtle}"

    # Background color of the percentage meters
    theme[meter_bg]="${colors.overlay}"

    # Misc colors for processes box including mini cpu graphs
    theme[proc_misc]="${colors.foam}"

    # CPU box outline color
    theme[cpu_box]="${colors.iris}"

    # Memory/disks box outline color
    theme[mem_box]="${colors.pine}"

    # Net box outline color
    theme[net_box]="${colors.foam}"

    # Processes box outline color
    theme[proc_box]="${colors.rose}"

    # Box divider line and target box outline color
    theme[div_line]="${colors.highlightMed}"

    # Temperature graph color
    theme[temp_start]="${colors.pine}"
    theme[temp_mid]="${colors.gold}"
    theme[temp_end]="${colors.love}"

    # CPU graph colors
    theme[cpu_start]="${colors.pine}"
    theme[cpu_mid]="${colors.foam}"
    theme[cpu_end]="${colors.iris}"

    # Mem/Disk free meter
    theme[free_start]="${colors.pine}"
    theme[free_mid]="${colors.foam}"
    theme[free_end]="${colors.iris}"

    # Mem/Disk cached meter
    theme[cached_start]="${colors.pine}"
    theme[cached_mid]="${colors.foam}"
    theme[cached_end]="${colors.iris}"

    # Mem/Disk available meter
    theme[available_start]="${colors.pine}"
    theme[available_mid]="${colors.foam}"
    theme[available_end]="${colors.iris}"

    # Mem/Disk used meter
    theme[used_start]="${colors.rose}"
    theme[used_mid]="${colors.gold}"
    theme[used_end]="${colors.love}"

    # Download graph colors
    theme[download_start]="${colors.pine}"
    theme[download_mid]="${colors.foam}"
    theme[download_end]="${colors.iris}"

    # Upload graph colors
    theme[upload_start]="${colors.rose}"
    theme[upload_mid]="${colors.gold}"
    theme[upload_end]="${colors.love}"

    # Process box color gradient for threads, mem and cpu usage
    theme[process_start]="${colors.pine}"
    theme[process_mid]="${colors.foam}"
    theme[process_end]="${colors.iris}"
  '';

  # Kvantum for better Qt theming
  home.packages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
  ];

  # Kvantum configuration
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=rose-pine
  '';

  # Kvantum Rosé Pine theme (simplified version)
  xdg.configFile."Kvantum/rose-pine/rose-pine.kvconfig".text = ''
    [%General]
    author=Rosé Pine
    comment=Rosé Pine theme for Kvantum
    x11drag=all
    alt_mnemonic=true
    left_tabs=false
    attach_active_tab=false
    mirror_doc_tabs=false
    group_toolbar_buttons=false
    toolbar_item_spacing=2
    toolbar_interior_spacing=2
    spread_progressbar=true
    composite=true
    menu_shadow_depth=6
    tooltip_shadow_depth=6
    scroll_width=12
    scroll_arrows=false
    scroll_min_extent=36
    transient_scrollbar=false
    slider_width=4
    slider_handle_width=18
    slider_handle_length=18
    tickless_slider_handle_size=18
    center_toolbar_handle=true
    check_size=16
    textless_progressbar=false
    progressbar_thickness=4
    menubar_mouse_tracking=true
    toolbutton_style=0
    double_click=false
    translucent_windows=true
    blurring=true
    popup_blurring=true
    vertical_spin_indicators=false
    spin_button_width=16
    fill_rubberband=false
    merge_menubar_with_toolbar=false
    small_icon_size=16
    large_icon_size=32
    button_icon_size=16
    toolbar_icon_size=22
    combo_as_lineedit=true
    square_combo_button=true
    combo_menu=true
    hide_combo_checkboxes=false
    combo_focus_rect=true
    spread_menuitems=true
    spread_header=true
    layout_spacing=3
    layout_margin=6
    submenu_overlap=0
    submenu_delay=150
    no_window_pattern=false
    respect_DE=true
    scrollable_menu=true
    no_inactiveness=false
    reduce_window_opacity=0
    reduce_menu_opacity=0
    click_behavior=0
    contrast=1.0
    dialog_button_layout=0
    intensity=1.0
    saturation=1.0
    shadowless_popup=false
    drag_from_buttons=false
    opaque=
    tree_branch_line=true

    [GeneralColors]
    window.color=${colors.base}
    base.color=${colors.surface}
    alt.base.color=${colors.overlay}
    button.color=${colors.overlay}
    light.color=${colors.highlightHigh}
    mid.light.color=${colors.highlightMed}
    dark.color=${colors.base}
    mid.color=${colors.highlightLow}
    highlight.color=${colors.iris}
    inactive.highlight.color=${colors.muted}
    text.color=${colors.text}
    window.text.color=${colors.text}
    button.text.color=${colors.text}
    disabled.text.color=${colors.muted}
    tooltip.text.color=${colors.text}
    highlight.text.color=${colors.base}
    link.color=${colors.foam}
    link.visited.color=${colors.iris}
    progress.indicator.text.color=${colors.base}

    [Hacks]
    transparent_dolphin_view=false
    transparent_ktitle_label=true
    transparent_menutitle=true
    transparent_pcmanfm_sidepane=true
    blur_translucent=true
    transparent_arrow_button=true
    lxqtmainmenu_iconsize=22
    normal_default_pushbutton=true
    iconless_pushbutton=false
    iconless_menu=false
    disabled_icon_opacity=70
    single_top_toolbar=false
    tint_on_mouseover=0
    no_selection_tint=false
    middle_click_scroll=false
    scroll_jump_workaround=true
    kcapacitybar_as_progressbar=true
    centered_forms=false
    kinetic_scrolling=true
    noninteger_translucency=false
    style_vertical_toolbars=false
  '';

  xdg.configFile."Kvantum/rose-pine/rose-pine.svg".text = ''
    <!-- Minimal SVG for Kvantum theme -->
    <svg xmlns="http://www.w3.org/2000/svg" width="100" height="100">
      <rect width="100" height="100" fill="${colors.base}"/>
    </svg>
  '';

  # Update Qt platform theme to use Kvantum
  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "kvantum";
  };
}
