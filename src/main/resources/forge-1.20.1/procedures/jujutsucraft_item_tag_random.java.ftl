<#include "mcelements.ftl">
/*@ItemStack*/(ForgeRegistries.ITEMS.tags().getTag(ItemTags.create(${toResourceLocation(generator.map(field$tag, "jujutsucraft_itemtags"))})).getRandomElement(RandomSource.create()).orElseGet(() -> Items.AIR))
