{ config, pkgs, ... }:

{
  # Glow - terminal markdown viewer
  home.packages = [ pkgs.glow ];

  # Glow configuration
  xdg.configFile."glow/glow.yml".text = ''
    # Style for markdown rendering
    style: "~/.config/glow/rose-pine.json"

    # Enable mouse support in TUI mode
    mouse: true

    # Use pager for output
    pager: true

    # Word wrap width (0 = terminal width)
    width: 100

    # Show hidden and ignored files in TUI file browser
    all: false
  '';

  # Rosé Pine theme for glow
  xdg.configFile."glow/rose-pine.json".text = builtins.toJSON {
    document = {
      block_prefix = "\n";
      block_suffix = "\n";
      color = "#e0def4";
      margin = 2;
    };
    block_quote = {
      indent = 1;
      indent_token = "│ ";
      color = "#908caa";
    };
    paragraph = {};
    list = {
      color = "#e0def4";
      level_indent = 2;
    };
    heading = {
      block_suffix = "\n";
      color = "#c4a7e7";
      bold = true;
    };
    h1 = {
      prefix = "◈ ";
      block_prefix = "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
      block_suffix = "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
      color = "#c4a7e7";
      bold = true;
    };
    h2 = {
      prefix = "◇ ";
      block_prefix = "\n──────────────────────────────\n";
      block_suffix = "\n";
      color = "#ebbcba";
      bold = true;
    };
    h3 = {
      prefix = "▸ ";
      block_prefix = "\n";
      color = "#f6c177";
      bold = true;
    };
    h4 = {
      prefix = "▹ ";
      color = "#9ccfd8";
      bold = true;
    };
    h5 = {
      prefix = "• ";
      color = "#31748f";
      bold = true;
    };
    h6 = {
      prefix = "◦ ";
      color = "#6e6a86";
      bold = true;
    };
    text = {};
    strikethrough = {
      crossed_out = true;
    };
    emph = {
      italic = true;
    };
    strong = {
      bold = true;
    };
    hr = {
      color = "#6e6a86";
      format = "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
    };
    item = {
      block_prefix = "• ";
    };
    enumeration = {
      block_prefix = ". ";
      color = "#31748f";
    };
    task = {
      ticked = "[✓] ";
      unticked = "[ ] ";
    };
    link = {
      color = "#31748f";
      underline = true;
    };
    link_text = {
      color = "#9ccfd8";
    };
    image = {
      color = "#31748f";
      underline = true;
    };
    image_text = {
      color = "#9ccfd8";
      format = "Image: {{.text}} →";
    };
    code = {
      color = "#ebbcba";
    };
    code_block = {
      color = "#e0def4";
      margin = 2;
      chroma = {
        text = { color = "#e0def4"; };
        error = { color = "#e0def4"; background_color = "#eb6f92"; };
        comment = { color = "#6e6a86"; };
        comment_preproc = { color = "#31748f"; };
        keyword = { color = "#31748f"; };
        keyword_reserved = { color = "#31748f"; };
        keyword_namespace = { color = "#31748f"; };
        keyword_type = { color = "#9ccfd8"; };
        operator = { color = "#31748f"; };
        punctuation = { color = "#908caa"; };
        name = { color = "#9ccfd8"; };
        name_builtin = { color = "#ebbcba"; };
        name_tag = { color = "#31748f"; };
        name_attribute = { color = "#f6c177"; };
        name_class = { color = "#9ccfd8"; };
        name_constant = { color = "#c4a7e7"; };
        name_decorator = { color = "#f6c177"; };
        name_exception = {};
        name_function = { color = "#ebbcba"; };
        name_other = {};
        literal = {};
        literal_number = { color = "#f6c177"; };
        literal_date = {};
        literal_string = { color = "#f6c177"; };
        literal_string_escape = { color = "#eb6f92"; };
        generic_deleted = { color = "#eb6f92"; };
        generic_emph = { italic = true; };
        generic_inserted = { color = "#31748f"; };
        generic_strong = { bold = true; };
        generic_subheading = { color = "#c4a7e7"; };
        background = { background_color = "#191724"; };
      };
    };
    table = {};
    definition_list = {};
    definition_term = {};
    definition_description = {
      block_prefix = "\n▸ ";
    };
    html_block = {};
    html_span = {};
  };
}
