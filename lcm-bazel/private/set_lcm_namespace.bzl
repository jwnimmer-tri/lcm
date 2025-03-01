load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")

def _impl(ctx):
    lcm_namespace = ctx.attr.lcm_namespace_flag[BuildSettingInfo].value
    out = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.expand_template(
        template = ctx.file.original_hdr,
        output = out,
        substitutions = {
            "@LCM_NAMESPACE@": lcm_namespace,
        },
    )
    return DefaultInfo(files = depset([out]))

set_lcm_namespace = rule(
    implementation = _impl,
    attrs = {
        "original_hdr": attr.label(
            allow_single_file = True,
            doc = "The lcm/lcm_namespace.h.in header to copy and edit.",
        ),
        "lcm_namespace_flag": attr.label(
            doc = "The string_flag to use for the new namespace.",
        ),
    },
    doc = "Copies lcm/version.h, changing its `#define LCM_NAMESPACE` value.",
)
