<#include "mcitems.ftl">
(${mappedMCItemToItemStackCode(input$item, 1)}.is(ItemTags.create(new ResourceLocation(${generator.map(field$tag, "jujutsucraft_itemtags")}))))
