<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="noindex, nofollow">
    <title>Stats</title>
    <link rel="icon" href="/favicon.ico" sizes="32x32">
    <link rel="icon" href="/static/images/icons/favicon.svg" type="image/svg+xml">
    <link rel="apple-touch-icon" href="/apple-touch-icon.png">
    <link rel="stylesheet" href="/static/css/site.css?v=${site.cssVersion}">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body class="bg-[#0a192f] text-[#8892b0] font-['Inter']">
    <div class="mx-auto min-h-screen max-w-4xl px-6 py-12 md:px-12">
        <header class="mb-12">
            <h1 class="text-3xl font-bold text-[#ccd6f6]">Visitors</h1>
            <p class="mt-2 text-sm">Unique visitors per day, crawlers excluded. Times are Asia/Ho_Chi_Minh.</p>
        </header>

        <section class="grid grid-cols-2 gap-4 sm:grid-cols-4">
            <div class="rounded border border-[#233554] p-5">
                <div class="text-xs font-bold uppercase tracking-widest text-[#8892b0]">Site, all time</div>
                <div class="mt-2 text-3xl font-bold text-[#64ffda]">${stats.siteTotal?c}</div>
            </div>
            <div class="rounded border border-[#233554] p-5">
                <div class="text-xs font-bold uppercase tracking-widest text-[#8892b0]">CV, all time</div>
                <div class="mt-2 text-3xl font-bold text-[#64ffda]">${stats.resumeTotal?c}</div>
            </div>
            <div class="rounded border border-[#233554] p-5">
                <div class="text-xs font-bold uppercase tracking-widest text-[#8892b0]">Today</div>
                <div class="mt-2 text-3xl font-bold text-[#ccd6f6]">${stats.today.site?c}</div>
                <div class="mt-1 text-xs">${stats.today.resume?c} opened the CV</div>
            </div>
            <div class="rounded border border-[#233554] p-5">
                <div class="text-xs font-bold uppercase tracking-widest text-[#8892b0]">CV rate</div>
                <div class="mt-2 text-3xl font-bold text-[#ccd6f6]">${stats.conversion?c}%</div>
                <div class="mt-1 text-xs">of visitors open it</div>
            </div>
        </section>

        <section class="mt-12">
            <div class="mb-4 flex items-center gap-6 text-xs font-bold uppercase tracking-widest">
                <span class="flex items-center"><span class="mr-2 h-3 w-3 rounded-sm bg-[#64ffda]"></span>Site</span>
                <span class="flex items-center"><span class="mr-2 h-3 w-3 rounded-sm bg-[#7c5cff]"></span>CV</span>
                <span class="ml-auto font-medium normal-case tracking-normal text-[#8892b0]">Last 30 days</span>
            </div>

            <div class="rounded border border-[#233554] p-3 sm:p-5">
                <div class="flex items-end gap-px sm:gap-1" style="height: 180px;">
                    <#list stats.days as day>
                        <div class="group relative flex h-full flex-1 items-end gap-0.5" title="${day.label}: ${day.site?c} visitors, ${day.resume?c} CV">
                            <div class="w-1/2 rounded-t-sm bg-[#64ffda]/80 transition-all group-hover:bg-[#64ffda]"
                                 style="height: ${((day.site * 100) / stats.maxCount)?round?c}%;"></div>
                            <div class="w-1/2 rounded-t-sm bg-[#7c5cff]/80 transition-all group-hover:bg-[#7c5cff]"
                                 style="height: ${((day.resume * 100) / stats.maxCount)?round?c}%;"></div>
                        </div>
                    </#list>
                </div>
                <div class="mt-3 flex gap-px text-[10px] text-[#8892b0] sm:gap-1">
                    <#list stats.days as day>
                        <div class="flex-1 text-center"><#if day?index % 5 == 0>${day.label}</#if></div>
                    </#list>
                </div>
            </div>
            <p class="mt-3 text-xs">Peak day in this window: ${stats.maxCount?c}. Bars are scaled to it.</p>
        </section>

        <section class="mt-12">
            <h2 class="text-xs font-bold uppercase tracking-widest text-[#ccd6f6]">Where visitors come from</h2>
            <#if stats.sourceRows?has_content>
                <div class="mt-4 rounded border border-[#233554]">
                    <table class="w-full text-left text-sm">
                        <thead>
                            <tr class="border-b border-[#233554] text-xs uppercase tracking-widest">
                                <th class="px-3 py-3 font-bold sm:px-5">Source</th>
                                <th class="whitespace-nowrap px-3 py-3 text-right font-bold sm:px-5">7 days</th>
                                <th class="whitespace-nowrap px-3 py-3 text-right font-bold sm:px-5">All time</th>
                                <th class="px-3 py-3 text-right font-bold sm:px-5">CV</th>
                            </tr>
                        </thead>
                        <tbody>
                            <#list stats.sourceRows as row>
                                <tr class="border-b border-[#233554]/60 last:border-0">
                                    <td class="w-full px-3 py-3 sm:px-5">
                                        <div class="break-words font-medium text-[#ccd6f6]">${row.name?html}</div>
                                        <div class="mt-1.5 h-1 rounded-full bg-[#233554]">
                                            <div class="h-1 rounded-full bg-[#64ffda]/80" style="width: ${row.share?c}%;"></div>
                                        </div>
                                    </td>
                                    <td class="px-3 py-3 text-right tabular-nums sm:px-5">${row.weekSite?c}</td>
                                    <td class="px-3 py-3 text-right tabular-nums text-[#ccd6f6] sm:px-5">${row.site?c}</td>
                                    <td class="px-3 py-3 text-right tabular-nums text-[#7c5cff] sm:px-5">${row.resume?c}</td>
                                </tr>
                            </#list>
                        </tbody>
                    </table>
                </div>
                <p class="mt-3 text-xs">
                    Unique visitors, counted since ${stats.sourcesSince}.
                    A CV opened from the site counts toward the source that brought the visitor.
                    Add <code class="text-[#ccd6f6]">?ref=name</code> to a link you share to give it its own row.
                </p>
            <#else>
                <p class="mt-4 rounded border border-[#233554] p-5 text-sm">No visits with a known source yet.</p>
            </#if>
        </section>

        <section class="mt-12">
            <h2 class="text-xs font-bold uppercase tracking-widest text-[#ccd6f6]">Résumé links</h2>
            <#if stats.links?has_content>
                <div class="mt-4 rounded border border-[#233554]">
                    <table class="w-full text-left text-sm">
                        <thead>
                            <tr class="border-b border-[#233554] text-xs uppercase tracking-widest">
                                <th class="px-3 py-3 font-bold sm:px-5">Link</th>
                                <th class="px-3 py-3 text-right font-bold sm:px-5">Opens</th>
                                <th class="hidden whitespace-nowrap px-3 py-3 font-bold sm:table-cell sm:px-5">First opened</th>
                                <th class="whitespace-nowrap px-3 py-3 font-bold sm:px-5">Last opened</th>
                            </tr>
                        </thead>
                        <tbody>
                            <#list stats.links as link>
                                <tr class="border-b border-[#233554]/60 last:border-0">
                                    <td class="w-full break-words px-3 py-3 font-medium text-[#ccd6f6] sm:px-5">/r/${link.name?html}</td>
                                    <td class="px-3 py-3 text-right tabular-nums text-[#64ffda] sm:px-5">${link.opens?c}</td>
                                    <td class="hidden whitespace-nowrap px-3 py-3 sm:table-cell sm:px-5">${link.firstOpenedLabel}</td>
                                    <td class="px-3 py-3 sm:whitespace-nowrap sm:px-5">${link.lastOpenedLabel}</td>
                                </tr>
                            </#list>
                        </tbody>
                    </table>
                </div>
            <#else>
                <p class="mt-4 rounded border border-[#233554] p-5 text-sm">No tracked links opened yet.</p>
            </#if>
            <p class="mt-3 text-xs">
                Send <code class="text-[#ccd6f6]">${site.baseUrl?replace("https://", "")}/r/company</code> with an application to see when that company opens your CV.
                Any lowercase name with letters, digits and dashes works, with no setup.
                Each visitor counts once per link per day.
            </p>
        </section>

        <footer class="mt-12 text-xs">
            <a href="/" class="hover:text-[#64ffda]">&larr; Back to the site</a>
        </footer>
    </div>
</body>
</html>
