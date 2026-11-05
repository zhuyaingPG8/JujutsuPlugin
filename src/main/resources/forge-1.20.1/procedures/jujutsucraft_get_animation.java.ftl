<#-- @formatter:off -->
(new Object(){
	public String getAnim(Entity _animEnt) {
		try {
			return (String) _animEnt.getClass().getField("animationprocedure").get(_animEnt);
		} catch (Exception _animEx) {
			return "empty";
		}
	}
}.getAnim(${input$entity}))
<#-- @formatter:on -->
