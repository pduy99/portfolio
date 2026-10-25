<#import "layout.ftl" as cs>
<#assign toc = [
    {"id": "problem", "label": "The problem"},
    {"id": "experience", "label": "The experience"},
    {"id": "architecture", "label": "Architecture"},
    {"id": "detection", "label": "Noticing a screenshot"},
    {"id": "survival", "label": "Staying alive"},
    {"id": "deletion", "label": "Deleting without nagging"},
    {"id": "shipping", "label": "Shipping"},
    {"id": "outcome", "label": "Outcome and next steps"}
]>
<@cs.page study=study toc=toc; part>
<#if part == "hero">
<section class="mx-auto max-w-6xl px-6 pt-14 md:px-12 md:pt-20">
    <div class="grid gap-10 lg:grid-cols-12 lg:items-end">
        <div class="lg:col-span-7">
            <div class="flex items-center gap-4">
                <img src="/static/media/case-studies/shot-clock/app-icon.png" alt="" width="56" height="56" class="h-14 w-14 rounded-full shadow-lg shadow-teal-500/20">
                <p class="text-sm font-medium text-[#a8b2d1]">Android app · Solo project · Dec 2025 to Aug 2026</p>
            </div>
            <h1 class="mt-6 text-5xl font-extrabold tracking-tight text-[#ccd6f6] sm:text-6xl">Shot Clock</h1>
            <p class="mt-5 max-w-xl text-lg leading-8 text-[#a8b2d1] sm:text-xl">
                Screenshots with an expiry date.
                Take one, tap how long it should live, and it deletes itself on time.
            </p>
            <div class="mt-8 flex flex-wrap items-center gap-3">
                <a href="https://play.google.com/store/apps/details?id=com.helios.shotclock" target="_blank" rel="noreferrer"
                   class="group inline-flex items-center gap-2 rounded bg-[#64ffda] px-5 py-3 text-sm font-semibold text-[#0a192f] transition hover:bg-[#8affe4]">
                    Get it on Google Play
                    <svg viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4 transition-transform group-hover:-translate-y-0.5 group-hover:translate-x-0.5 motion-reduce:transition-none" aria-hidden="true"><path fill-rule="evenodd" d="M5.22 14.78a.75.75 0 001.06 0l7.22-7.22v5.69a.75.75 0 001.5 0v-7.5a.75.75 0 00-.75-.75h-7.5a.75.75 0 000 1.5h5.69l-7.22 7.22a.75.75 0 000 1.06z" clip-rule="evenodd"/></svg>
                </a>
                <a href="#architecture" class="rounded border border-[#233554] px-5 py-3 text-sm font-semibold text-[#ccd6f6] transition-colors hover:border-[#64ffda]/60 hover:text-[#64ffda]">Skip to the engineering</a>
            </div>
        </div>
        <dl class="grid grid-cols-2 gap-px overflow-hidden rounded-xl border border-[#233554] bg-[#233554] lg:col-span-5">
            <div class="bg-[#0a192f] p-5">
                <dt class="text-xs font-bold uppercase tracking-widest">Role</dt>
                <dd class="mt-2 text-sm text-[#ccd6f6]">Everything: product, design, engineering, release</dd>
            </div>
            <div class="bg-[#0a192f] p-5">
                <dt class="text-xs font-bold uppercase tracking-widest">Platform</dt>
                <dd class="mt-2 text-sm text-[#ccd6f6]">Android 7.0 to 16, on Pixel and manufacturer skins</dd>
            </div>
            <div class="bg-[#0a192f] p-5">
                <dt class="text-xs font-bold uppercase tracking-widest">Stack</dt>
                <dd class="mt-2 text-sm text-[#ccd6f6]">Kotlin, Jetpack Compose, Hilt, Room, WorkManager</dd>
            </div>
            <div class="bg-[#0a192f] p-5">
                <dt class="text-xs font-bold uppercase tracking-widest">Status</dt>
                <dd class="mt-2 text-sm text-[#ccd6f6]">Live on Google Play, version 1.3.2</dd>
            </div>
        </dl>
    </div>

    <figure class="relative mx-auto mt-14 max-w-[420px] md:max-w-none">
        <div class="pointer-events-none absolute -inset-6 -z-10 rounded-[2.5rem] bg-[#64ffda]/10 blur-3xl" aria-hidden="true"></div>
        <div class="relative overflow-hidden rounded-3xl bg-[#f6f4f3] shadow-2xl shadow-black/40 ring-1 ring-white/10">
            <video id="demo-video" class="block aspect-[9/16] w-full md:aspect-video"
                   muted loop playsinline preload="metadata"
                   src="/static/media/case-studies/shot-clock/demo-landscape.mp4"
                   poster="/static/media/case-studies/shot-clock/demo-landscape.jpg"
                   data-landscape="/static/media/case-studies/shot-clock/demo-landscape.mp4"
                   data-landscape-poster="/static/media/case-studies/shot-clock/demo-landscape.jpg"
                   data-portrait="/static/media/case-studies/shot-clock/demo-portrait.mp4"
                   data-portrait-poster="/static/media/case-studies/shot-clock/demo-portrait.jpg"
                   aria-label="Shot Clock demo: a screenshot is taken, the user picks how long to keep it, and it is deleted on schedule.">
            </video>
            <div class="absolute bottom-3 right-3 flex gap-2">
                <button type="button" id="demo-toggle" aria-label="Pause the demo"
                        class="flex h-9 w-9 items-center justify-center rounded-full bg-[#0a192f]/70 text-white backdrop-blur transition hover:bg-[#0a192f]/90 focus-visible:outline focus-visible:outline-2 focus-visible:outline-[#64ffda]">
                    <svg data-icon="pause" viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4" aria-hidden="true"><path d="M5.75 3a.75.75 0 00-.75.75v12.5c0 .414.336.75.75.75h1.5a.75.75 0 00.75-.75V3.75A.75.75 0 007.25 3h-1.5zM12.75 3a.75.75 0 00-.75.75v12.5c0 .414.336.75.75.75h1.5a.75.75 0 00.75-.75V3.75a.75.75 0 00-.75-.75h-1.5z"/></svg>
                    <svg data-icon="play" viewBox="0 0 20 20" fill="currentColor" class="hidden h-4 w-4" aria-hidden="true"><path d="M6.3 2.84A1.5 1.5 0 004 4.11v11.78a1.5 1.5 0 002.3 1.27l9.344-5.891a1.5 1.5 0 000-2.538L6.3 2.841z"/></svg>
                </button>
                <button type="button" id="demo-sound" aria-label="Turn sound on"
                        class="flex h-9 w-9 items-center justify-center rounded-full bg-[#0a192f]/70 text-white backdrop-blur transition hover:bg-[#0a192f]/90 focus-visible:outline focus-visible:outline-2 focus-visible:outline-[#64ffda]">
                    <svg data-icon="muted" viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4" aria-hidden="true"><path d="M9.547 3.062A.75.75 0 0110 3.75v12.5a.75.75 0 01-1.264.546L4.703 13H3.167a.75.75 0 01-.7-.48A6.985 6.985 0 012 10c0-.887.165-1.737.468-2.52a.75.75 0 01.7-.48h1.535l4.033-3.796a.75.75 0 01.811-.142zM13.28 7.22a.75.75 0 10-1.06 1.06L13.94 10l-1.72 1.72a.75.75 0 001.06 1.06L15 11.06l1.72 1.72a.75.75 0 101.06-1.06L16.06 10l1.72-1.72a.75.75 0 00-1.06-1.06L15 8.94l-1.72-1.72z"/></svg>
                    <svg data-icon="sound" viewBox="0 0 20 20" fill="currentColor" class="hidden h-4 w-4" aria-hidden="true"><path d="M10 3.75a.75.75 0 00-1.264-.546L4.703 7H3.167a.75.75 0 00-.7.48A6.985 6.985 0 002 10c0 .887.165 1.737.468 2.52.111.29.39.48.7.48h1.535l4.033 3.796A.75.75 0 0010 16.25V3.75zM15.95 5.05a.75.75 0 00-1.06 1.061 5.5 5.5 0 010 7.778.75.75 0 001.06 1.06 7 7 0 000-9.899z"/><path d="M13.829 7.172a.75.75 0 00-1.061 1.06 2.5 2.5 0 010 3.536.75.75 0 001.06 1.06 4 4 0 000-5.656z"/></svg>
                </button>
            </div>
        </div>
    </figure>

    <dl class="mt-14 grid grid-cols-2 gap-x-6 gap-y-8 border-y border-[#233554] py-10 sm:grid-cols-4">
        <div>
            <dt class="text-xs font-bold uppercase tracking-widest">Gradle modules</dt>
            <dd class="mt-2 text-4xl font-bold text-[#64ffda]">10</dd>
            <dd class="mt-1 text-sm">split into public API and hidden implementation</dd>
        </div>
        <div>
            <dt class="text-xs font-bold uppercase tracking-widest">Recovery layers</dt>
            <dd class="mt-2 text-4xl font-bold text-[#64ffda]">4</dd>
            <dd class="mt-1 text-sm">keeping detection alive under Android's background limits</dd>
        </div>
        <div>
            <dt class="text-xs font-bold uppercase tracking-widest">Latest release</dt>
            <dd class="mt-2 text-4xl font-bold text-[#64ffda]">1.3.2</dd>
            <dd class="mt-1 text-sm">eight months of releases through closed testing to production</dd>
        </div>
        <div>
            <dt class="text-xs font-bold uppercase tracking-widest">Languages</dt>
            <dd class="mt-2 text-4xl font-bold text-[#64ffda]">5</dd>
            <dd class="mt-1 text-sm">English, German, Spanish, French and Vietnamese</dd>
        </div>
    </dl>
</section>
<div class="h-16"></div>
<#elseif part == "body">

<@cs.section id="problem" number="01" title="Screenshots are notes we never clean up">
    <p>
        Most screenshots are temporary.
        A parking bay, a boarding pass, a one-time code, a QR ticket, a product to compare later.
        They are useful for an hour or a day, then they sit in the gallery forever, burying the photos that matter and filling storage.
    </p>
    <p>
        Neither Android nor the popular gallery apps lets you give a file an expiry date.
        Cleaning up means scrolling back through hundreds of images and deciding one by one, long after you remember why you took them.
    </p>
    <@cs.callout label="The goal">
        Decide a screenshot's lifespan at the only moment you know it: right after you take it.
        One tap, under a second, without opening an app.
    </@cs.callout>
</@cs.section>

<@cs.section id="experience" number="02" title="One tap at the moment of capture">
    <p>
        Shot Clock runs quietly in the background.
        When a screenshot lands, a small floating bubble appears on top of whatever app you are in.
    </p>
    <ol class="!mt-8 grid gap-4 sm:grid-cols-3">
        <li class="rounded-xl border border-[#233554] bg-[#0d1f3c] p-5">
            <p class="font-['JetBrains_Mono'] text-xs text-[#64ffda]">1 · Capture</p>
            <p class="mt-2 font-semibold text-[#ccd6f6]">Take a screenshot</p>
            <p class="mt-1 text-sm leading-6">As usual, with any button combination or gesture.</p>
        </li>
        <li class="rounded-xl border border-[#233554] bg-[#0d1f3c] p-5">
            <p class="font-['JetBrains_Mono'] text-xs text-[#64ffda]">2 · Decide</p>
            <p class="mt-2 font-semibold text-[#ccd6f6]">Tap 1 hour, 1 day or keep</p>
            <p class="mt-1 text-sm leading-6">The bubble fades away if you ignore it. Times and colours are configurable.</p>
        </li>
        <li class="rounded-xl border border-[#233554] bg-[#0d1f3c] p-5">
            <p class="font-['JetBrains_Mono'] text-xs text-[#64ffda]">3 · Forget</p>
            <p class="mt-2 font-semibold text-[#ccd6f6]">It deletes itself on time</p>
            <p class="mt-1 text-sm leading-6">The home screen shows what is scheduled and how much space has been freed.</p>
        </li>
    </ol>
    <p>
        The simplicity is the product.
        Every hard problem in this project exists to keep that one tap reliable on real phones.
    </p>
</@cs.section>

<@cs.section id="architecture" number="03" title="Modules with hard boundaries">
    <p>
        Even as a solo project, I built it the way I would build a team codebase.
        Each feature is split into a small <code class="rounded bg-[#112240] px-1.5 py-0.5 text-[13px] text-[#ccd6f6]">api</code> module that other code may depend on,
        and an <code class="rounded bg-[#112240] px-1.5 py-0.5 text-[13px] text-[#ccd6f6]">impl</code> module nobody else can see.
        Only the app module knows every implementation, and Hilt wires them together.
    </p>
    <@cs.figure caption="Module graph, taken from the Gradle build files. Implementations depend only on other features' public APIs, never on each other.">
        <svg viewBox="0 0 720 330" class="hidden h-auto w-full sm:block" role="img" aria-label="Module graph: app depends on every feature; each feature implementation depends on other features' API modules and on core data, design system and common.">
            <defs>
                <marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M0 0L10 5L0 10z" fill="#495670"/></marker>
                <marker id="arrow-teal" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M0 0L10 5L0 10z" fill="#64ffda"/></marker>
            </defs>
            <g font-family="JetBrains Mono, monospace" font-size="12">
                <!-- app -->
                <rect x="290" y="16" width="140" height="40" rx="8" fill="#112240" stroke="#64ffda" stroke-opacity=".6"/>
                <text x="360" y="41" text-anchor="middle" fill="#ccd6f6">:app</text>

                <!-- features -->
                <#list [{"x": 30, "name": "home"}, {"x": 260, "name": "onboarding"}, {"x": 490, "name": "overlay"}] as f>
                    <rect x="${f.x}" y="100" width="200" height="110" rx="10" fill="#0a192f" stroke="#233554"/>
                    <text x="${f.x + 100}" y="122" text-anchor="middle" fill="#8892b0" font-size="11">feature:${f.name}</text>
                    <rect x="${f.x + 14}" y="136" width="78" height="56" rx="6" fill="#112240" stroke="#64ffda" stroke-opacity=".35"/>
                    <text x="${f.x + 53}" y="169" text-anchor="middle" fill="#64ffda">api</text>
                    <rect x="${f.x + 108}" y="136" width="78" height="56" rx="6" fill="#112240" stroke="#233554"/>
                    <text x="${f.x + 147}" y="169" text-anchor="middle" fill="#ccd6f6">impl</text>
                </#list>

                <!-- app to features -->
                <path d="M330 56 L130 100" stroke="#495670" fill="none" marker-end="url(#arrow)"/>
                <path d="M360 56 L360 100" stroke="#495670" fill="none" marker-end="url(#arrow)"/>
                <path d="M390 56 L590 100" stroke="#495670" fill="none" marker-end="url(#arrow)"/>

                <!-- impl to other features' api (teal, dashed) -->
                <path d="M177 192 C 200 245, 510 245, 530 194" stroke="#64ffda" stroke-opacity=".7" stroke-dasharray="4 4" fill="none" marker-end="url(#arrow-teal)"/>
                <path d="M407 192 C 425 222, 535 225, 558 194" stroke="#64ffda" stroke-opacity=".7" stroke-dasharray="4 4" fill="none" marker-end="url(#arrow-teal)"/>
                <path d="M393 192 C 370 225, 110 230, 83 194" stroke="#64ffda" stroke-opacity=".7" stroke-dasharray="4 4" fill="none" marker-end="url(#arrow-teal)"/>

                <!-- shared modules -->
                <#list [{"x": 46, "name": ":core:data", "note": "Room · DataStore · WorkManager"}, {"x": 268, "name": ":designsystem", "note": "Compose theme · components"}, {"x": 490, "name": ":common", "note": "permissions · navigation"}] as m>
                    <rect x="${m.x}" y="262" width="184" height="52" rx="8" fill="#112240" stroke="#233554"/>
                    <text x="${m.x + 92}" y="284" text-anchor="middle" fill="#ccd6f6">${m.name}</text>
                    <text x="${m.x + 92}" y="302" text-anchor="middle" fill="#6b7a99" font-size="10">${m.note}</text>
                </#list>
            </g>
        </svg>
        <div class="space-y-3 p-4 font-['JetBrains_Mono'] text-xs sm:hidden">
            <div class="rounded-lg border border-[#64ffda]/60 bg-[#112240] p-3 text-center text-[#ccd6f6]">:app <span class="block pt-1 text-[11px] text-[#6b7a99]">wires every implementation</span></div>
            <#list [
                {"name": "home", "uses": "overlay api"},
                {"name": "onboarding", "uses": "home api, overlay api"},
                {"name": "overlay", "uses": "no other feature"}
            ] as f>
            <div class="rounded-lg border border-[#233554] p-3">
                <div class="flex items-center justify-between gap-3">
                    <span class="text-[#8892b0]">feature:${f.name}</span>
                    <span class="flex gap-1.5"><span class="rounded border border-[#64ffda]/35 bg-[#112240] px-2 py-1 text-[#64ffda]">api</span><span class="rounded border border-[#233554] bg-[#112240] px-2 py-1 text-[#ccd6f6]">impl</span></span>
                </div>
                <p class="mt-2 text-[11px] text-[#6b7a99]">impl uses: <span class="text-[#64ffda]/80">${f.uses}</span></p>
            </div>
            </#list>
            <div class="grid grid-cols-3 gap-2 text-center">
                <div class="rounded-lg border border-[#233554] bg-[#112240] px-1 py-2 text-[#ccd6f6]">:core:data</div>
                <div class="rounded-lg border border-[#233554] bg-[#112240] px-1 py-2 text-[#ccd6f6]">:design&shy;system</div>
                <div class="rounded-lg border border-[#233554] bg-[#112240] px-1 py-2 text-[#ccd6f6]">:common</div>
            </div>
        </div>
    </@cs.figure>
    <p>
        The payoff is concrete.
        Onboarding can start the detection service through the overlay API without knowing a service exists.
        Changing how the service survives touched one module and recompiled almost nothing else.
        A script regenerates the module graphs, so the documentation cannot drift from the build.
    </p>
    <p>
        Data stays simple on purpose: Room holds the scheduled deletions, DataStore holds preferences and the running total of space saved,
        and a WorkManager job deletes whatever is due.
    </p>
</@cs.section>

<@cs.section id="detection" number="04" title="Noticing a screenshot within a second" kicker="Hard part 1">
    <p>
        Android has no "screenshot taken" broadcast for third-party apps.
        Shot Clock watches the MediaStore image collection with a <code class="rounded bg-[#112240] px-1.5 py-0.5 text-[13px] text-[#ccd6f6]">ContentObserver</code>
        from a foreground service, and decides for every change whether it is a new screenshot.
    </p>
    <p>That decision is harder than it looks, because the observer fires for everything and often more than once:</p>
    <ul class="list-none space-y-3">
        <li class="flex gap-3"><span class="mt-2.5 h-1.5 w-1.5 shrink-0 rounded-full bg-[#64ffda]"></span><span><strong class="font-semibold text-[#ccd6f6]">Half-written files.</strong> On Android 10 and later the system inserts the row before the image is finished. Rows still marked pending are skipped until the next change.</span></li>
        <li class="flex gap-3"><span class="mt-2.5 h-1.5 w-1.5 shrink-0 rounded-full bg-[#64ffda]"></span><span><strong class="font-semibold text-[#ccd6f6]">Old images.</strong> Deletions, edits and gallery syncs also fire the observer. Only images added in the last 10 seconds count.</span></li>
        <li class="flex gap-3"><span class="mt-2.5 h-1.5 w-1.5 shrink-0 rounded-full bg-[#64ffda]"></span><span><strong class="font-semibold text-[#ccd6f6]">Duplicates.</strong> One screenshot can trigger several callbacks. Remembering the highest media ID already handled makes the bubble appear exactly once.</span></li>
        <li class="flex gap-3"><span class="mt-2.5 h-1.5 w-1.5 shrink-0 rounded-full bg-[#64ffda]"></span><span><strong class="font-semibold text-[#ccd6f6]">Manufacturers.</strong> Pixel, Samsung and others save to different folders with different names, so the check looks at file name, absolute path and relative path.</span></li>
    </ul>
    <@cs.figure caption="The filter every MediaStore change goes through before the bubble appears. Simplified from ScreenshotDetectionService.">
<pre class="overflow-x-auto p-5 font-['JetBrains_Mono'] text-[12px] leading-6 text-[#a8b2d1] sm:text-[13px]"><code><span class="text-[#c792ea]">if</span> (id &lt;= lastProcessedId) <span class="text-[#c792ea]">return</span>   <span class="text-[#495670]">// seen it already</span>
<span class="text-[#c792ea]">if</span> (isPending) <span class="text-[#c792ea]">return</span>               <span class="text-[#495670]">// still being written</span>
<span class="text-[#c792ea]">if</span> (now - dateAdded &gt; <span class="text-[#f78c6c]">10</span>) <span class="text-[#c792ea]">return</span>    <span class="text-[#495670]">// not a new capture</span>
<span class="text-[#c792ea]">if</span> (isScreenshot(name, path, relativePath)) {
    lastProcessedId = id
    overlay.<span class="text-[#82aaff]">show</span>(path, name, uri)
}</code></pre>
    </@cs.figure>
</@cs.section>

<@cs.section id="survival" number="05" title="Staying alive when Android wants you dead" kicker="Hard part 2">
    <p>
        Detection only works while the service runs, and modern Android is built to stop exactly this kind of app.
        Doze, app standby buckets, manufacturer battery savers and memory pressure all kill background work,
        and since Android 12 an app in the background is not even allowed to restart its own foreground service.
    </p>
    <p>
        No single mechanism survives every phone, so the service is guarded by four layers, each catching what the one above misses.
    </p>
    <@cs.figure caption="Each layer is cheap on its own and covers a different way the service dies. Intervals are tuned so the app stays out of manufacturers' abuse heuristics.">
        <div class="divide-y divide-[#233554]">
            <#list [
                {"n": "0", "name": "Foreground service", "detail": "START_STICKY asks the system to recreate the service after a low-memory kill.", "when": "always on", "w": "100%"},
                {"n": "1", "name": "Exact alarm watchdog", "detail": "Checks every 15 minutes and restarts the service if it is gone. Falls back to an inexact alarm when the user has not granted exact alarms, which Android 13 denies by default.", "when": "every 15 min", "w": "70%"},
                {"n": "2", "name": "WorkManager monitor", "detail": "A periodic job that survives reboots and app updates, scheduled once and never duplicated.", "when": "every 2 h", "w": "45%"},
                {"n": "3", "name": "Alarm clock watchdog", "detail": "Registered as a real alarm clock, which manufacturers are reluctant to suppress, so it gets through deep sleep. Capped at three a day to avoid looking abusive.", "when": "every 8 h", "w": "25%"}
            ] as layer>
            <div class="grid gap-3 p-5 sm:grid-cols-12 sm:items-center">
                <div class="flex items-center gap-3 sm:col-span-4">
                    <span class="flex h-7 w-7 shrink-0 items-center justify-center rounded-md bg-[#64ffda]/10 font-['JetBrains_Mono'] text-xs text-[#64ffda]">L${layer.n}</span>
                    <span class="font-semibold text-[#ccd6f6]">${layer.name}</span>
                </div>
                <p class="text-sm leading-6 sm:col-span-6">${layer.detail}</p>
                <div class="sm:col-span-2 sm:text-right">
                    <span class="font-['JetBrains_Mono'] text-xs text-[#a8b2d1]">${layer.when}</span>
                    <div class="mt-1.5 h-1 rounded-full bg-[#233554] sm:ml-auto sm:w-20"><div class="h-1 rounded-full bg-[#64ffda]/70" style="width: ${layer.w};"></div></div>
                </div>
            </div>
            </#list>
        </div>
    </@cs.figure>
    <p>
        Two details mattered more than the layers themselves.
        First, every restart path treats a refused start as normal: on Android 12 and later a watchdog may not be allowed to start the service, so it quietly gives up and lets the next layer, or the user opening the app, try again.
        Second, the home screen offers to exempt the app from battery optimisation and explains why, which helps more than any amount of code on aggressive manufacturer builds.
    </p>
    <@cs.callout label="Lesson from production" tone="amber">
        Version 1.3.1 exists because Play Console reported crashes from the watchdogs themselves on Pixel and realme phones.
        The exact alarm permission can be revoked at any moment, and a background service start can be refused,
        and both surfaced as crashes in code paths I had only tested with permissions granted.
        The fix was to check before every call, fall back instead of throwing, and log process exit reasons in debug builds so silent kills stop being a mystery.
    </@cs.callout>
</@cs.section>

<@cs.section id="deletion" number="06" title="Deleting files without asking every time" kicker="Hard part 3">
    <p>
        Since Android 11, an app cannot delete another app's images without the user's consent, and screenshots belong to the system.
        Asking for confirmation every time would defeat the point of the app, so I compared the three ways to get that consent.
    </p>
    <@cs.figure caption="The three options for deleting screenshots on Android 11 and later. The first release used the first option and moved to the third.">
        <div class="overflow-x-auto">
            <table class="w-full min-w-[560px] text-left text-sm">
                <thead>
                    <tr class="border-b border-[#233554] text-xs uppercase tracking-widest">
                        <th class="p-4 font-bold">Option</th>
                        <th class="p-4 font-bold">What the user sees</th>
                        <th class="p-4 font-bold">Catch</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-[#233554]/70">
                    <tr>
                        <td class="p-4 align-top font-medium text-[#ccd6f6]">All files access</td>
                        <td class="p-4 align-top">One scary system screen granting access to every file on the phone.</td>
                        <td class="p-4 align-top">Far more access than the app needs, and Google Play restricts it to apps like file managers.</td>
                    </tr>
                    <tr>
                        <td class="p-4 align-top font-medium text-[#ccd6f6]">MediaStore delete request</td>
                        <td class="p-4 align-top">A system dialog for every deletion batch.</td>
                        <td class="p-4 align-top">Needs the user present, so it cannot run on a schedule. It breaks the core promise.</td>
                    </tr>
                    <tr class="bg-[#64ffda]/[0.05]">
                        <td class="p-4 align-top font-medium text-[#64ffda]">Folder grant <span class="ml-1 rounded-full bg-[#64ffda]/10 px-2 py-0.5 text-[11px] font-semibold">chosen</span></td>
                        <td class="p-4 align-top">During onboarding, pick the Screenshots folder once with the system file picker.</td>
                        <td class="p-4 align-top">One extra onboarding step, which needed a guided dialog to explain.</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </@cs.figure>
    <p>
        The folder grant is persistent and scoped to exactly one folder, so the deletion job can run unattended while the app never sees the rest of the phone.
        On Android 10 and earlier the job falls back to a direct file delete, and if a file has already gone it simply drops the schedule entry.
    </p>
    <p>
        Moving off all-files access meant rewriting onboarding into three steps with clear permission cards,
        which turned a policy problem into a better first-run experience.
    </p>
</@cs.section>

<@cs.section id="shipping" number="07" title="Shipping like a team of one">
    <p>
        Releases are fully automated, so shipping a fix is a branch and a button rather than an afternoon of manual steps.
    </p>
    <@cs.figure caption="From branch to production. The artifact users get is the exact one that was tested.">
        <ol class="grid gap-px bg-[#233554] sm:grid-cols-4">
            <#list [
                {"step": "Pull request", "detail": "Unit tests, lint, and instrumented tests on emulators at API 27, 30 and 36."},
                {"step": "release/vX.Y.Z", "detail": "CI checks the branch matches the version, builds a signed bundle and uploads it to closed testing."},
                {"step": "Verify", "detail": "The build is tagged as a release candidate with the exact bundle attached, then tested on devices."},
                {"step": "Promote", "detail": "A manual workflow promotes that same build to production, with a staged rollout percentage."}
            ] as s>
            <li class="bg-[#0d1f3c] p-5">
                <p class="font-['JetBrains_Mono'] text-xs text-[#64ffda]">${(s?index + 1)?string["00"]}</p>
                <p class="mt-2 font-semibold text-[#ccd6f6]">${s.step}</p>
                <p class="mt-1 text-sm leading-6">${s.detail}</p>
            </li>
            </#list>
        </ol>
    </@cs.figure>
    <p>
        Version codes come from the commit count, so any tag rebuilds to the same number and codes always increase.
        Release notes ship in five languages with every version.
    </p>
</@cs.section>

<@cs.section id="outcome" number="08" title="Outcome and what is next">
    <ul class="list-none space-y-3">
        <li class="flex gap-3"><span class="mt-2.5 h-1.5 w-1.5 shrink-0 rounded-full bg-[#64ffda]"></span><span>Live on Google Play. The first versions shipped eight days after the first commit, and 1.3.2 eight months later.</span></li>
        <li class="flex gap-3"><span class="mt-2.5 h-1.5 w-1.5 shrink-0 rounded-full bg-[#64ffda]"></span><span>Moved off all-files access to a single folder grant, keeping the app within Play policy and asking for far less.</span></li>
        <li class="flex gap-3"><span class="mt-2.5 h-1.5 w-1.5 shrink-0 rounded-full bg-[#64ffda]"></span><span>Production crashes from the service watchdogs found through Play Console and fixed in the following release.</span></li>
    </ul>
    <@cs.callout label="Next">
        Cover the watchdog chain with instrumented tests that revoke permissions and kill the process on the emulator matrix,
        so the next Android release breaks a test before it breaks a phone.
        After that, a home screen widget for the screenshots due to expire today.
    </@cs.callout>
</@cs.section>

</#if>
</@cs.page>
