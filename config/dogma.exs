use Mix.Config
alias Dogma.Rule

config :dogma,

  # Select a set of rules as a base
  rule_set: Dogma.RuleSet.All,

  # Pick paths not to lint
  exclude: [
    ~r(/event_page_web/assets/),
    ~r(/event_page_viewer_web/assets/)
  ],

  # Override an existing rule configuration
  override: [
    %Rule.LineLength{ max_length: 120 },
    %Rule.HardTabs{ enabled: false },
  ]
