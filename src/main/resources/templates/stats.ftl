<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="noindex, nofollow">
    <title>Stats</title>
    <script src="https://cdn.tailwindcss.com"></script>
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

            <div class="overflow-x-auto rounded border border-[#233554] p-5">
                <div class="flex min-w-[640px] items-end gap-1" style="height: 180px;">
                    <#list stats.days as day>
                        <div class="group relative flex h-full flex-1 items-end gap-0.5" title="${day.label}: ${day.site?c} visitors, ${day.resume?c} CV">
                            <div class="w-1/2 rounded-t-sm bg-[#64ffda]/80 transition-all group-hover:bg-[#64ffda]"
                                 style="height: ${((day.site * 100) / stats.maxCount)?round?c}%;"></div>
                            <div class="w-1/2 rounded-t-sm bg-[#7c5cff]/80 transition-all group-hover:bg-[#7c5cff]"
                                 style="height: ${((day.resume * 100) / stats.maxCount)?round?c}%;"></div>
                        </div>
                    </#list>
                </div>
                <div class="mt-3 flex min-w-[640px] gap-1 text-[10px] text-[#8892b0]">
                    <#list stats.days as day>
                        <div class="flex-1 text-center"><#if day?index % 5 == 0>${day.label}</#if></div>
                    </#list>
                </div>
            </div>
            <p class="mt-3 text-xs">Peak day in this window: ${stats.maxCount?c}. Bars are scaled to it.</p>
        </section>

        <footer class="mt-12 text-xs">
            <a href="/" class="hover:text-[#64ffda]">&larr; Back to the site</a>
        </footer>
    </div>
</body>
</html>
