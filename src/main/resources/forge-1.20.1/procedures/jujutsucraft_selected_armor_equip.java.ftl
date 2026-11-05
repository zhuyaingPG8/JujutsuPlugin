<#include "mcitems.ftl">
SelectedArmorEquipProcedure.execute(${input$entity},
		${mappedMCItemToItemStackCode(input$chest)},
		${mappedMCItemToItemStackCode(input$feet)},
		${mappedMCItemToItemStackCode(input$head)},
		${mappedMCItemToItemStackCode(input$legs)},
		${mappedMCItemToItemStackCode(input$other1)},
		${mappedMCItemToItemStackCode(input$other2)},
		${mappedMCItemToItemStackCode(input$mainhand)},
		${mappedMCItemToItemStackCode(input$offhand)});
