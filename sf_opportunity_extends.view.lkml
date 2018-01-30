include: "_opportunity.view.lkml"
include: "_opportunity_history.view.lkml"
view: opportunity_history {
  extends: [_opportunity_history]
}

view: opportunity {
  extends: [_opportunity]
}
