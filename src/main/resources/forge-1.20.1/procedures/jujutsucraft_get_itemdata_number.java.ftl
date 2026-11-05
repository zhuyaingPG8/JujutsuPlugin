<#include "mcitems.ftl">
${mappedMCItemToItemStackCode(input$item, 1)}.getOrCreateTag().getDouble(${generator.map(field$key, "jujutsucraft_itemdata")})
