<#include "mcitems.ftl">
${generator.map(field$procedure, "jujutsucraft_proc_void")}.execute(${mappedMCItemToItemStackCode(input$item)});
