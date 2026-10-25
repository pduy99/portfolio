<#import "layout.ftl" as cs>
<#assign toc = [
    {"id": "context", "label": "Context"},
    {"id": "rebuild", "label": "Map and search rebuild"},
    {"id": "map-component", "label": "Map component"},
    {"id": "search", "label": "Search with KMP"},
    {"id": "ai", "label": "AI Chat and Voice"},
    {"id": "automotive", "label": "In the car"},
    {"id": "takeaways", "label": "What I took away"}
]>
<#assign code = "rounded bg-[#112240] px-1.5 py-0.5 text-[13px] text-[#ccd6f6]">
<#macro dot><span class="mt-2.5 h-1.5 w-1.5 shrink-0 rounded-full bg-[#64ffda]"></span></#macro>
<@cs.page study=study toc=toc; part>
<#if part == "hero">
<section class="mx-auto max-w-6xl px-6 pt-14 md:px-12 md:pt-20">
    <div class="grid gap-10 lg:grid-cols-12 lg:items-end">
        <div class="lg:col-span-7">
            <div class="flex items-center gap-4">
                <span class="flex h-14 w-14 items-center justify-center rounded-2xl bg-[#e11f26] font-['JetBrains_Mono'] text-xl font-medium tracking-tighter text-white shadow-lg shadow-red-500/20" aria-hidden="true">///</span>
                <p class="text-sm font-medium text-[#a8b2d1]">Senior Android Engineer · Oct 2023 to present</p>
            </div>
            <h1 class="mt-6 text-5xl font-extrabold tracking-tight text-[#ccd6f6] sm:text-6xl">what3words</h1>
            <p class="mt-5 max-w-xl text-lg leading-8 text-[#a8b2d1] sm:text-xl">
                Leading Android on a maps app with more than 10 million downloads:
                a rebuild of its busiest screens, two open-source libraries, and AI features for Pro.
            </p>
            <div class="mt-8 flex flex-wrap items-center gap-3">
                <a href="https://play.google.com/store/apps/details?id=com.what3words.android" target="_blank" rel="noreferrer"
                   class="group inline-flex items-center gap-2 rounded bg-[#64ffda] px-5 py-3 text-sm font-semibold text-[#0a192f] transition hover:bg-[#8affe4]">
                    The app on Google Play
                    <svg viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4 transition-transform group-hover:-translate-y-0.5 group-hover:translate-x-0.5 motion-reduce:transition-none" aria-hidden="true"><path fill-rule="evenodd" d="M5.22 14.78a.75.75 0 001.06 0l7.22-7.22v5.69a.75.75 0 001.5 0v-7.5a.75.75 0 00-.75-.75h-7.5a.75.75 0 000 1.5h5.69l-7.22 7.22a.75.75 0 000 1.06z" clip-rule="evenodd"/></svg>
                </a>
                <a href="#rebuild" class="rounded border border-[#233554] px-5 py-3 text-sm font-semibold text-[#ccd6f6] transition-colors hover:border-[#64ffda]/60 hover:text-[#64ffda]">Skip to the engineering</a>
            </div>
        </div>
        <dl class="grid grid-cols-2 gap-px overflow-hidden rounded-xl border border-[#233554] bg-[#233554] lg:col-span-5">
            <div class="bg-[#0a192f] p-5">
                <dt class="text-xs font-bold uppercase tracking-widest">Role</dt>
                <dd class="mt-2 text-sm text-[#ccd6f6]">Android lead: architecture, standards and technology choices</dd>
            </div>
            <div class="bg-[#0a192f] p-5">
                <dt class="text-xs font-bold uppercase tracking-widest">Team</dt>
                <dd class="mt-2 text-sm text-[#ccd6f6]">Android and iOS engineers, product and design</dd>
            </div>
            <div class="bg-[#0a192f] p-5">
                <dt class="text-xs font-bold uppercase tracking-widest">Stack</dt>
                <dd class="mt-2 text-sm text-[#ccd6f6]">Kotlin, Jetpack Compose, MVI, Kotlin Multiplatform, Hilt</dd>
            </div>
            <div class="bg-[#0a192f] p-5">
                <dt class="text-xs font-bold uppercase tracking-widest">Platforms</dt>
                <dd class="mt-2 text-sm text-[#ccd6f6]">Android phones and cars, with logic shared to iOS</dd>
            </div>
        </dl>
    </div>

    <figure class="relative mt-14">
        <div class="pointer-events-none absolute inset-x-10 -inset-y-4 -z-10 rounded-[3rem] bg-[#1e5bb8]/20 blur-3xl" aria-hidden="true"></div>
        <div class="grid grid-cols-3 items-center gap-3 sm:gap-6 lg:mx-auto lg:max-w-4xl">
            <img src="/static/media/case-studies/what3words/store-search.jpg" alt="what3words store screenshot: find any destination with just three words" width="720" height="1280" loading="eager"
                 class="w-full rounded-xl shadow-2xl shadow-black/40 ring-1 ring-white/10 sm:rounded-2xl lg:-rotate-3 lg:translate-y-6">
            <img src="/static/media/case-studies/what3words/store-map.jpg" alt="what3words store screenshot: the main map screen with search, a selected square and its what3words address" width="720" height="1280" loading="eager"
                 class="relative z-10 w-full rounded-xl shadow-2xl shadow-black/50 ring-1 ring-white/10 sm:rounded-2xl">
            <img src="/static/media/case-studies/what3words/store-voice.jpg" alt="what3words store screenshot: AI Chat with voice input in what3words Pro" width="720" height="1280" loading="eager"
                 class="w-full rounded-xl shadow-2xl shadow-black/40 ring-1 ring-white/10 sm:rounded-2xl lg:rotate-3 lg:translate-y-6">
        </div>
        <figcaption class="mt-10 text-center text-xs text-[#6b7a99]">Public Google Play screenshots. Main map and search in the middle, AI Chat with voice input on the right.</figcaption>
    </figure>

    <dl class="mt-12 grid grid-cols-2 gap-x-6 gap-y-8 border-y border-[#233554] py-10 sm:grid-cols-4">
        <div>
            <dt class="text-xs font-bold uppercase tracking-widest">Downloads</dt>
            <dd class="mt-2 text-4xl font-bold text-[#64ffda]">10M+</dd>
            <dd class="mt-1 text-sm">on Google Play, the app every change ships to</dd>
        </div>
        <div>
            <dt class="text-xs font-bold uppercase tracking-widest">Legacy code removed</dt>
            <dd class="mt-2 text-4xl font-bold text-[#64ffda]">20,000</dd>
            <dd class="mt-1 text-sm">lines, from the map and search rebuild</dd>
        </div>
        <div>
            <dt class="text-xs font-bold uppercase tracking-widest">UI performance</dt>
            <dd class="mt-2 text-4xl font-bold text-[#64ffda]">82%</dd>
            <dd class="mt-1 text-sm">better on the main map screen, measured with Macrobenchmark</dd>
        </div>
        <div>
            <dt class="text-xs font-bold uppercase tracking-widest">Open source</dt>
            <dd class="mt-2 text-4xl font-bold text-[#64ffda]">2</dd>
            <dd class="mt-1 text-sm">libraries I led: the map component and the KMP search wrapper</dd>
        </div>
    </dl>
</section>
<div class="h-16"></div>
<#elseif part == "body">

<@cs.section id="context" number="01" title="A map app where every square has an address">
    <p>
        what3words divides the world into 3 metre squares and gives each one a unique three-word address, such as <span class="font-['JetBrains_Mono'] text-[#ccd6f6]">///filled.count.soap</span>.
        People use it to meet up, get deliveries to the right entrance, and tell emergency services exactly where they are.
    </p>
    <p>
        The Android app has more than 10 million downloads, so its two core screens carry most of the product: the map where you find and select a square, and the search that gets you there.
        I joined as a senior Android engineer and became the lead for the Android side,
        working with product, design and the iOS engineers on what to build, and owning how Android builds it.
    </p>
</@cs.section>

<@cs.section id="rebuild" number="02" title="Rebuilding the most complex screens" kicker="Map and search">
    <p>
        The main map and search were the most complex feature in the app, and the oldest.
        They were built on XML views and LiveData, slow and hard to maintain, and the map had to handle hundreds of markers at once.
        Every new feature made the screen a little harder to reason about.
    </p>
    <p>
        I led the migration to MVI and Jetpack Compose.
        Each screen now has a single immutable state, every user action is an intent, and one reducer decides the next state.
        The UI only renders state and sends intents, so it no longer holds any logic of its own.
    </p>
    <@cs.figure caption="The MVI loop the map and search screens moved to. One place decides what the screen shows, which makes every bug reproducible from a state and an intent.">
        <svg viewBox="0 0 720 232" class="hidden h-auto w-full sm:block" role="img" aria-label="MVI loop: the Compose UI sends intents to the view model, its reducer produces a new immutable state, the UI renders that state, and side effects such as navigation go out as one-off events.">
            <defs>
                <marker id="mvi-arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M0 0L10 5L0 10z" fill="#64ffda"/></marker>
            </defs>
            <g font-family="JetBrains Mono, monospace" font-size="13">
                <rect x="24" y="64" width="190" height="82" rx="12" fill="#112240" stroke="#233554"/>
                <text x="119" y="98" text-anchor="middle" fill="#ccd6f6">Compose UI</text>
                <text x="119" y="120" text-anchor="middle" fill="#6b7a99" font-size="11">renders state only</text>

                <rect x="282" y="52" width="190" height="106" rx="12" fill="#112240" stroke="#64ffda" stroke-opacity=".6"/>
                <text x="377" y="88" text-anchor="middle" fill="#ccd6f6">ViewModel</text>
                <text x="377" y="110" text-anchor="middle" fill="#64ffda" font-size="11">reduce(state, intent)</text>
                <text x="377" y="130" text-anchor="middle" fill="#6b7a99" font-size="11">use cases · repositories</text>

                <rect x="540" y="64" width="156" height="82" rx="12" fill="#112240" stroke="#233554"/>
                <text x="618" y="98" text-anchor="middle" fill="#ccd6f6">State</text>
                <text x="618" y="120" text-anchor="middle" fill="#6b7a99" font-size="11">one, immutable</text>

                <path d="M214 84 L280 84" stroke="#64ffda" fill="none" marker-end="url(#mvi-arrow)"/>
                <text x="247" y="74" text-anchor="middle" fill="#a8b2d1" font-size="11">intent</text>
                <path d="M472 104 L538 104" stroke="#64ffda" fill="none" marker-end="url(#mvi-arrow)"/>
                <path d="M618 146 C 618 196, 119 196, 119 148" stroke="#64ffda" stroke-opacity=".7" fill="none" marker-end="url(#mvi-arrow)"/>
                <text x="368" y="222" text-anchor="middle" fill="#a8b2d1" font-size="11">state as a StateFlow, collected by the UI</text>
                <path d="M377 52 C 377 18, 160 18, 140 62" stroke="#495670" stroke-dasharray="4 4" fill="none" marker-end="url(#mvi-arrow)"/>
                <text x="258" y="22" text-anchor="middle" fill="#6b7a99" font-size="11">one-off events: navigate, share</text>
            </g>
        </svg>
        <ol class="space-y-2 p-4 font-['JetBrains_Mono'] text-xs sm:hidden">
            <#list [
                {"name": "Compose UI", "note": "renders state only", "edge": "sends an intent"},
                {"name": "ViewModel", "note": "reduce(state, intent)", "edge": "emits a new state"},
                {"name": "State", "note": "one, immutable", "edge": "collected by the UI as a StateFlow"}
            ] as n>
            <li>
                <div class="rounded-lg border <#if n.name == "ViewModel">border-[#64ffda]/60<#else>border-[#233554]</#if> bg-[#112240] p-3 text-center">
                    <span class="text-[#ccd6f6]">${n.name}</span>
                    <span class="block pt-1 text-[11px] <#if n.name == "ViewModel">text-[#64ffda]<#else>text-[#6b7a99]</#if>">${n.note}</span>
                </div>
                <p class="py-2 text-center text-[11px] text-[#a8b2d1]"><span class="text-[#64ffda]" aria-hidden="true">↓</span> ${n.edge}<#if n?is_last> <span class="text-[#64ffda]" aria-hidden="true">↺</span></#if></p>
            </li>
            </#list>
            <li class="text-center text-[11px] text-[#6b7a99]">One-off events such as navigate and share go out separately.</li>
        </ol>
    </@cs.figure>
    <p>
        The map itself moved onto a shared map component our team built, covered in the next section.
        That replaced the app's own marker and camera code and gave the screen one map API, whichever provider is underneath.
    </p>
    <p>
        I implemented Macrobenchmark tests for the main map screen, so the result was a measurement rather than a feeling.
    </p>
    <dl class="!mt-8 grid gap-4 sm:grid-cols-2">
        <div class="rounded-xl border border-[#233554] bg-[#0d1f3c] p-5">
            <dt class="text-xs font-bold uppercase tracking-widest">Code</dt>
            <dd class="mt-2 text-3xl font-bold text-[#64ffda]">−20,000 lines</dd>
            <dd class="mt-1 text-sm leading-6">of legacy code deleted.</dd>
        </div>
        <div class="rounded-xl border border-[#233554] bg-[#0d1f3c] p-5">
            <dt class="text-xs font-bold uppercase tracking-widest">Performance</dt>
            <dd class="mt-2 text-3xl font-bold text-[#64ffda]">82% better</dd>
            <dd class="mt-1 text-sm leading-6">UI performance on the main map screen, measured with the Macrobenchmark suite.</dd>
        </div>
    </dl>
    <@cs.callout label="Why it worked">
        The biggest win was not Compose, it was deleting code.
        A single state per screen made whole classes of synchronisation bugs impossible, and the benchmark kept the team honest about whether each change helped.
    </@cs.callout>
</@cs.section>

<@cs.section id="map-component" number="03" title="One map API over Google Maps and Mapbox" kicker="Open source">
    <p>
        what3words apps need the same things on any map: the 3 metre grid, markers with addresses, square selection, and controls for location and map type.
        It has to work on both Google Maps and Mapbox, and writing that twice in every app was not an option.
    </p>
    <p>
        Our team built <a href="https://github.com/what3words/w3w-android-map-components" target="_blank" rel="noreferrer" class="font-medium text-[#64ffda] hover:underline">w3w-android-map-components</a>,
        an open-source library with a Compose API and a View API, and I led its architecture.
        The app's map screen is built on it, so the rebuild and the library improved each other.
    </p>
    <@cs.figure caption="The library's layers. Apps talk to one component and one state holder; the provider underneath can be swapped with a single parameter.">
        <div class="divide-y divide-[#233554] font-['JetBrains_Mono'] text-xs sm:text-[13px]">
            <#list [
                {"layer": "Your app", "detail": "Places one composable and observes the map state.", "tone": "muted"},
                {"layer": "W3WMapComponent", "detail": "The map, grid, markers, selection and built-in buttons for recall, my location and map type.", "tone": "teal"},
                {"layer": "W3WMapManager", "detail": "Single state holder: camera, selected square, named marker lists. Survives configuration changes.", "tone": "teal"},
                {"layer": "Google Maps · Mapbox", "detail": "Provider-specific drawers render the same state on either SDK.", "tone": "muted"}
            ] as l>
            <div class="grid gap-1 p-4 sm:grid-cols-12 sm:items-center sm:gap-4 sm:p-5">
                <span class="sm:col-span-4 <#if l.tone == "teal">text-[#64ffda]<#else>text-[#ccd6f6]</#if>">${l.layer}</span>
                <span class="font-['Inter'] text-sm leading-6 text-[#8892b0] sm:col-span-8">${l.detail}</span>
            </div>
            </#list>
        </div>
    </@cs.figure>
    <p>
        Performance work landed in the library, where every app benefits.
        One example: the map's content is wrapped with <code class="${code}">movableContentOf</code>, so it is not recomposed from scratch whenever the map recomposes,
        and camera bounds are computed without extra coroutine hops and without crashing when the map has not finished laying out.
    </p>
</@cs.section>

<@cs.section id="search" number="04" title="One search engine for Android and iOS" kicker="Kotlin Multiplatform">
    <p>
        I introduced Kotlin Multiplatform at what3words by building shared internal libraries, and took them from nothing to production with a team of Android and iOS engineers.
        The clearest example is search, which is public as <a href="https://github.com/what3words/w3w-kmp-search-wrapper" target="_blank" rel="noreferrer" class="font-medium text-[#64ffda] hover:underline">w3w-kmp-search-wrapper</a>.
    </p>
    <p>
        Every map app needs the same search box, and "useful results" is a mix of very different sources:
    </p>
    <ul class="list-none space-y-3">
        <li class="flex gap-3"><@dot/><span><strong class="font-semibold text-[#ccd6f6]">Local parsers</strong> that should never touch the network: three-word addresses, raw coordinates, British National Grid references.</span></li>
        <li class="flex gap-3"><@dot/><span><strong class="font-semibold text-[#ccd6f6]">Geocoders</strong> for everything else, like Mapbox and Google Places, which cost money per session.</span></li>
        <li class="flex gap-3"><@dot/><span><strong class="font-semibold text-[#ccd6f6]">Platform sources</strong> that only exist on one side, like Apple Maps on iOS.</span></li>
    </ul>
    <p>The library puts all of them behind one client, configured with a small DSL:</p>
    <@cs.figure caption="Installing providers. Equal priority forms a tier that runs concurrently; lower tiers only run if no higher tier can handle the query.">
<pre class="overflow-x-auto p-5 font-['JetBrains_Mono'] text-[12px] leading-6 text-[#a8b2d1] sm:text-[13px]"><code><span class="text-[#c792ea]">val</span> client = <span class="text-[#82aaff]">W3WSearchClient</span>(textDataSource) {
    <span class="text-[#82aaff]">install</span>(ThreeWordAddressSearch, priority = <span class="text-[#f78c6c]">10</span>)
    <span class="text-[#82aaff]">install</span>(CoordinatesSearch, priority = <span class="text-[#f78c6c]">9</span>)
    <span class="text-[#82aaff]">install</span>(MapboxSearch, MapboxConfig(apiKey), priority = <span class="text-[#f78c6c]">1</span>)
}

<span class="text-[#c792ea]">val</span> results = client.<span class="text-[#82aaff]">search</span>(<span class="text-[#c3e88d]">"filled.count.soap"</span>)   <span class="text-[#495670]">// suggestions</span>
<span class="text-[#c792ea]">val</span> address = client.<span class="text-[#82aaff]">resolve</span>(results.first())     <span class="text-[#495670]">// only when tapped</span></code></pre>
    </@cs.figure>
    <p>Three decisions shaped it:</p>
    <ol class="!mt-6 space-y-4">
        <li class="rounded-xl border border-[#233554] bg-[#0d1f3c] p-5">
            <p class="font-semibold text-[#ccd6f6]"><span class="mr-2 font-['JetBrains_Mono'] text-xs text-[#64ffda]">01</span>Priority is a number, not an order</p>
            <p class="mt-1 text-sm leading-6">Providers with the same priority run concurrently and their results merge. Local parsers answer instantly together, and paid geocoders only run as a fallback, without any scheduling code in the app.</p>
        </li>
        <li class="rounded-xl border border-[#233554] bg-[#0d1f3c] p-5">
            <p class="font-semibold text-[#ccd6f6]"><span class="mr-2 font-['JetBrains_Mono'] text-xs text-[#64ffda]">02</span>Resolving is a separate step</p>
            <p class="mt-1 text-sm leading-6">Search returns display-ready suggestions without coordinates. Only the one the user taps is resolved to a full address, which matches how Mapbox and Google bill sessions.</p>
        </li>
        <li class="rounded-xl border border-[#233554] bg-[#0d1f3c] p-5">
            <p class="font-semibold text-[#ccd6f6]"><span class="mr-2 font-['JetBrains_Mono'] text-xs text-[#64ffda]">03</span>Every built-in uses the public contract</p>
            <p class="mt-1 text-sm leading-6">A provider is two tiny interfaces and nothing else: no registry, no reflection, no private API. If a built-in could not be written against the contract, the contract grew. Failures are typed results, so one broken provider never poisons the merged list.</p>
        </li>
    </ol>
    <@cs.callout label="The moment it paid off">
        An iOS engineer asked whether iOS could use Apple Maps instead of paying for Google.
        The usual answer would be to add a Kotlin plugin to the shared module and republish.
        Instead, with SKIE bridging Kotlin <code class="${code}">suspend</code> functions to Swift <code class="${code}">async</code>,
        they wrote the provider in pure Swift inside the iOS app, and the Kotlin dispatcher runs it alongside the built-ins as if it were native.
        iOS went from consumer of the library to a peer that can extend it.
    </@cs.callout>
    <p>
        It ships to Android through Maven Central and to iOS as an XCFramework through Swift Package Manager, and reached 1.0 in July 2026.
        The rough edges were honest ones: heterogeneous lists do not bridge cleanly to Swift, and Kotlin generics in the install DSL had to be mirrored by a Swift-friendly API.
    </p>
</@cs.section>

<@cs.section id="ai" number="05" title="AI Chat and Voice for what3words Pro" kicker="From idea to product">
    <p>
        For the Pro 5.0 release I led the Android side of AI Chat and AI Voice with one other Android engineer.
        I worked with the product manager and designer from the first idea, gave early feedback on what was feasible, and turned the concept into a shippable product.
        On the engineering side I defined the architecture, the coding standards and the technologies we used.
    </p>
    <p>
        The interesting problems were not in calling a model.
        They were in turning a conversation into something a location app can act on, reliably, while the user is still talking.
    </p>
    <@cs.figure caption="From speech to an action the app can trust. The model proposes; the app validates before anything becomes tappable.">
        <ol class="grid gap-px bg-[#233554] sm:grid-cols-4">
            <#list [
                {"step": "Speak or type", "detail": "Voice is transcribed on the fly, so the request appears while the user is still talking."},
                {"step": "Structured reply", "detail": "The model answers in a fixed schema: text to show, plus actions from a closed list such as search, navigate, save or share."},
                {"step": "Validate", "detail": "Every three-word address in an action is checked against the what3words API before it is used."},
                {"step": "Act", "detail": "Valid actions become cards with a map preview, one tap from navigation or sharing."}
            ] as s>
            <li class="bg-[#0d1f3c] p-5">
                <p class="font-['JetBrains_Mono'] text-xs text-[#64ffda]">${(s?index + 1)?string["00"]}</p>
                <p class="mt-2 font-semibold text-[#ccd6f6]">${s.step}</p>
                <p class="mt-1 text-sm leading-6">${s.detail}</p>
            </li>
            </#list>
        </ol>
    </@cs.figure>
    <ul class="list-none space-y-3">
        <li class="flex gap-3"><@dot/><span><strong class="font-semibold text-[#ccd6f6]">Unpredictable answers.</strong> Model output is treated like any untrusted input. Replies are parsed into a sealed set of actions the app already knows how to perform, so the model can never invent a new behaviour. Anything that does not parse falls back to a plain text reply instead of an error.</span></li>
        <li class="flex gap-3"><@dot/><span><strong class="font-semibold text-[#ccd6f6]">Addresses that look right but are not.</strong> A model can produce three plausible words that point to the wrong place, or nowhere. No address from the model is shown as tappable until the what3words API confirms it; if it fails, the app offers the closest AutoSuggest matches instead.</span></li>
        <li class="flex gap-3"><@dot/><span><strong class="font-semibold text-[#ccd6f6]">Acting in real time.</strong> Replies stream into the chat as they arrive, and each action card appears the moment its address is validated, so the user can tap through to the map before the full answer has finished.</span></li>
    </ul>
</@cs.section>

<@cs.section id="automotive" number="06" title="In the car">
    <div class="grid gap-6 sm:grid-cols-5 sm:items-center">
        <div class="space-y-5 sm:col-span-3">
            <p>
                I also built production Android Automotive apps with Jetpack Compose and the Car App Library,
                deployed to major automotive suppliers including Pleos, Visteon and Harman.
            </p>
            <p>The same search and saved locations, redesigned for a glance from the driver's seat.</p>
        </div>
        <img src="/static/media/case-studies/what3words/store-car.jpg" alt="what3words Pro on an Android Automotive head unit, showing a three-word address on the map with search, saved locations and settings" width="1024" height="768" loading="lazy"
             class="w-full rounded-xl ring-1 ring-white/10 sm:col-span-2">
    </div>
</@cs.section>

<@cs.section id="takeaways" number="07" title="What I took away">
    <ul class="list-none space-y-3">
        <li class="flex gap-3"><@dot/><span><strong class="font-semibold text-[#ccd6f6]">Measure before you refactor.</strong> A benchmark turned a rewrite from a matter of taste into a decision the whole team could check.</span></li>
        <li class="flex gap-3"><@dot/><span><strong class="font-semibold text-[#ccd6f6]">The best code is often the code you delete.</strong> Twenty thousand fewer lines made the screen faster and every later feature cheaper.</span></li>
        <li class="flex gap-3"><@dot/><span><strong class="font-semibold text-[#ccd6f6]">Build shared code for peers, not consumers.</strong> Kotlin Multiplatform landed because iOS could extend the library in Swift, not just call it.</span></li>
        <li class="flex gap-3"><@dot/><span><strong class="font-semibold text-[#ccd6f6]">Treat AI output as untrusted input.</strong> Constrain it, validate it, and give it a graceful fallback, and it becomes a feature people can rely on.</span></li>
    </ul>
</@cs.section>

</#if>
</@cs.page>
