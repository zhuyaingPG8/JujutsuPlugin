<#if settings.getMCreatorDependencies()?seq_contains("jujutsucraft")
      && data.getModElement().getName()?contains("Barrier")
      && !data.blockBase?has_content
      && !data.hasGravity>
<#assign var_extends_class = "JujutsuBarrierBase">
</#if>
<#include "block/block.java.ftl">