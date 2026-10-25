<#--
  Shared layout and building blocks for case study pages.
  A case study template imports this file and wraps its sections in <@cs.page>.
-->

<#macro page study toc>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <#assign pageTitle = "${study.title} case study - Duy Pham">
    <title>${pageTitle?html}</title>
    <meta name="description" content="${study.summary?html}">
    <link rel="canonical" href="${site.baseUrl}${study.path}">
    <meta name="theme-color" content="#0a192f">

    <meta property="og:type" content="article">
    <meta property="og:site_name" content="Duy Pham">
    <meta property="og:title" content="${pageTitle?html}">
    <meta property="og:description" content="${study.summary?html}">
    <meta property="og:url" content="${site.baseUrl}${study.path}">
    <meta property="og:image" content="${site.baseUrl}${study.previewImage}">
    <meta property="og:image:width" content="1200">
    <meta property="og:image:height" content="630">
    <meta name="twitter:card" content="summary_large_image">

    <link rel="icon" href="/favicon.ico" sizes="32x32">
    <link rel="icon" href="/static/images/icons/favicon.svg" type="image/svg+xml">
    <link rel="apple-touch-icon" href="/apple-touch-icon.png">
    <link rel="stylesheet" href="/static/css/site.css?v=${site.cssVersion}">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <style>
        .spotlight {
            position: fixed;
            inset: 0;
            z-index: 30;
            pointer-events: none;
            background: radial-gradient(600px circle at var(--x) var(--y), rgba(29, 78, 216, 0.15), transparent 80%);
        }
        .active .nav-indicator { width: 2.5rem; background-color: #64ffda; }
        .active .nav-text { color: #e2e8f0; }
        .active .nav-number { color: #64ffda; }
    </style>
</head>
<body class="bg-[#0a192f] font-['Inter'] text-[#8892b0] antialiased selection:bg-[#64ffda]/20 selection:text-[#ccd6f6]">
    <div id="spotlight" class="spotlight"></div>

    <header class="mx-auto flex max-w-6xl items-center justify-between px-6 pt-8 md:px-12">
        <a href="/#projects" class="group inline-flex items-center gap-2 text-sm font-medium text-[#a8b2d1] hover:text-[#64ffda]">
            <svg viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4 transition-transform group-hover:-translate-x-1 motion-reduce:transition-none" aria-hidden="true"><path fill-rule="evenodd" d="M17 10a.75.75 0 01-.75.75H5.612l4.158 3.96a.75.75 0 11-1.04 1.08l-5.5-5.25a.75.75 0 010-1.08l5.5-5.25a.75.75 0 111.04 1.08L5.612 9.25H16.25A.75.75 0 0117 10z" clip-rule="evenodd"/></svg>
            Duy Pham
        </a>
        <span class="font-['JetBrains_Mono'] text-xs uppercase tracking-widest text-[#64ffda]">Case study</span>
    </header>

    <#nested "hero">

    <div class="mx-auto max-w-6xl px-6 pb-10 md:px-12 lg:grid lg:grid-cols-12 lg:gap-12">
        <aside class="hidden lg:col-span-3 lg:block">
            <nav class="nav sticky top-24" aria-label="Sections">
                <p class="mb-4 text-xs font-bold uppercase tracking-widest text-[#ccd6f6]">Contents</p>
                <ol>
                    <#list toc as item>
                        <li>
                            <a class="group flex items-center py-2" href="#${item.id}">
                                <span class="nav-number mr-3 w-5 font-['JetBrains_Mono'] text-xs text-[#495670] group-hover:text-[#64ffda]">${(item?index + 1)?string["00"]}</span>
                                <span class="nav-indicator mr-3 h-px w-5 bg-[#233554] transition-all group-hover:w-10 group-hover:bg-[#64ffda] motion-reduce:transition-none"></span>
                                <span class="nav-text text-sm text-[#8892b0] group-hover:text-[#e2e8f0]">${item.label}</span>
                            </a>
                        </li>
                    </#list>
                </ol>
            </nav>
        </aside>
        <article class="lg:col-span-9 lg:max-w-3xl">
            <#nested "body">
        </article>
    </div>

    <footer class="border-t border-[#233554]">
        <div class="mx-auto flex max-w-6xl flex-col gap-6 px-6 py-12 sm:flex-row sm:items-center sm:justify-between md:px-12">
            <div>
                <p class="text-lg font-semibold text-[#ccd6f6]">Thanks for reading.</p>
                <p class="mt-1 text-sm">Happy to walk through any of these decisions in more depth.</p>
            </div>
            <div class="flex flex-wrap gap-3">
                <a href="/resume" target="_blank" rel="noreferrer" class="rounded border border-[#64ffda]/60 px-4 py-2 text-sm font-semibold text-[#64ffda] transition-colors hover:bg-[#64ffda]/10">View résumé</a>
                <a href="/#projects" class="rounded border border-[#233554] px-4 py-2 text-sm font-semibold text-[#ccd6f6] transition-colors hover:border-[#64ffda]/60 hover:text-[#64ffda]">All projects</a>
            </div>
        </div>
    </footer>

    <script src="/static/js/main.js"></script>
    <script src="/static/js/case-study.js"></script>
</body>
</html>
</#macro>

<#-- A numbered section with its heading. -->
<#macro section id number title kicker="">
    <section id="${id}" class="scroll-mt-24 border-t border-[#233554]/70 py-14 first:border-0 first:pt-0">
        <p class="font-['JetBrains_Mono'] text-xs uppercase tracking-widest text-[#64ffda]">${number}<#if kicker?has_content><span class="text-[#495670]"> / ${kicker}</span></#if></p>
        <h2 class="mt-3 text-2xl font-bold tracking-tight text-[#ccd6f6] sm:text-3xl">${title}</h2>
        <div class="mt-6 space-y-5 text-[15px] leading-7 sm:text-base">
            <#nested>
        </div>
    </section>
</#macro>

<#-- A highlighted aside: a takeaway, a constraint or a lesson. -->
<#macro callout label tone="teal">
    <div class="rounded-lg border <#if tone == "amber">border-amber-300/25 bg-amber-300/[0.04]<#else>border-[#64ffda]/25 bg-[#64ffda]/[0.04]</#if> p-5">
        <p class="text-xs font-bold uppercase tracking-widest <#if tone == "amber">text-amber-200<#else>text-[#64ffda]</#if>">${label}</p>
        <div class="mt-2 text-[15px] leading-7 text-[#a8b2d1]"><#nested></div>
    </div>
</#macro>

<#-- A diagram or code sample with a caption underneath. -->
<#macro figure caption>
    <figure class="!mt-8">
        <div class="overflow-hidden rounded-xl border border-[#233554] bg-[#0d1f3c]">
            <#nested>
        </div>
        <figcaption class="mt-3 text-xs leading-5 text-[#6b7a99]">${caption}</figcaption>
    </figure>
</#macro>
