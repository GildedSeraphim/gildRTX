const std = @import("std");
const vk = @cImport({
    @cInclude("vulkan/vulkan.h");
});

pub fn main() !void {
    var instance_info = vk.VkInstanceCreateInfo{
        .sType = vk.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
        .pNext = null,
        .flags = 0,
        .pApplicationInfo = null,
        .enabledExtensionCount = 0,
        .ppEnabledExtensionNames = null,
        .enabledLayerCount = 0,
        .ppEnabledLayerNames = null,
    };

    var instance: vk.VkInstance = undefined;
    const result = vk.vkCreateInstance(&instance_info, null, &instance);
    if (result != vk.VK_SUCCESS) {
        return error.VulkanInitializationFailed;
    }
}
