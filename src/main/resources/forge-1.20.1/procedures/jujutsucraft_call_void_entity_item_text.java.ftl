<#include "mcitems.ftl">
${generator.map(field$procedure, "jujutsucraft_proc_void")}.execute(${input$entity}, ${mappedMCItemToItemStackCode(input$item)}, ${input$text});
