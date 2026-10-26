<#import "layout.ftl" as cs>
<#--
  Set to true once demo-landscape.mp4, demo-portrait.mp4 and their .jpg posters are in
  static/media/case-studies/subly/. Until then the hero shows a reserved frame.
-->
<#assign demoReady = false>
<#assign toc = [
    {"id": "problem", "label": "The problem"},
    {"id": "pipeline", "label": "The pipeline"},
    {"id": "recognition", "label": "Choosing speech models"},
    {"id": "translation", "label": "Translation that fits the phone"},
    {"id": "realtime", "label": "Making it real time"},
    {"id": "measuring", "label": "Measuring on real phones"},
    {"id": "privacy", "label": "Private by design"},
    {"id": "status", "label": "Status and next steps"}
]>
<#assign code = "rounded bg-[#112240] px-1.5 py-0.5 text-[13px] text-[#ccd6f6]">
<#macro dot><span class="mt-2.5 h-1.5 w-1.5 shrink-0 rounded-full bg-[#64ffda]"></span></#macro>
<@cs.page study=study toc=toc; part>
<#if part == "hero">
<section class="mx-auto max-w-6xl px-6 pt-14 md:px-12 md:pt-20">
    <div class="grid gap-10 lg:grid-cols-12 lg:items-end">
        <div class="lg:col-span-7">
            <div class="flex items-center gap-4">
                <img src="/static/media/case-studies/subly/app-icon.png" alt="" width="56" height="56" class="h-14 w-14 rounded-2xl shadow-lg shadow-black/40">
                <p class="text-sm font-medium text-[#a8b2d1]">Android app and SDK · Solo project · May 2026 to present</p>
            </div>
            <h1 class="mt-6 flex flex-wrap items-center gap-x-5 gap-y-3 text-5xl font-extrabold tracking-tight text-[#ccd6f6] sm:text-6xl">
                Subly
                <span class="rounded-full border border-amber-200/30 px-3 py-1 text-xs font-semibold uppercase tracking-wider text-amber-200">In closed testing</span>
            </h1>
            <p class="mt-5 max-w-xl text-lg leading-8 text-[#a8b2d1] sm:text-xl">
                Live, translated captions over the videos and audio playing on your phone.
                Speech recognition and translation run entirely on the device, so no audio ever leaves it.
            </p>
            <div class="mt-8 flex flex-wrap items-center gap-3">
                <a href="https://github.com/pduy99/subly-android-sdk" target="_blank" rel="noreferrer"
                   class="group inline-flex items-center gap-2 rounded bg-[#64ffda] px-5 py-3 text-sm font-semibold text-[#0a192f] transition hover:bg-[#8affe4]">
                    The SDK on GitHub
                    <svg viewBox="0 0 20 20" fill="currentColor" class="h-4 w-4 transition-transform group-hover:-translate-y-0.5 group-hover:translate-x-0.5 motion-reduce:transition-none" aria-hidden="true"><path fill-rule="evenodd" d="M5.22 14.78a.75.75 0 001.06 0l7.22-7.22v5.69a.75.75 0 001.5 0v-7.5a.75.75 0 00-.75-.75h-7.5a.75.75 0 000 1.5h5.69l-7.22 7.22a.75.75 0 000 1.06z" clip-rule="evenodd"/></svg>
                </a>
                <a href="#pipeline" class="rounded border border-[#233554] px-5 py-3 text-sm font-semibold text-[#ccd6f6] transition-colors hover:border-[#64ffda]/60 hover:text-[#64ffda]">Skip to the engineering</a>
            </div>
        </div>
        <dl class="grid grid-cols-2 gap-px overflow-hidden rounded-xl border border-[#233554] bg-[#233554] lg:col-span-5">
            <div class="bg-[#0a192f] p-5">
                <dt class="text-xs font-bold uppercase tracking-widest">Role</dt>
                <dd class="mt-2 text-sm text-[#ccd6f6]">Everything: SDK, app, model selection, benchmarks</dd>
            </div>
            <div class="bg-[#0a192f] p-5">
                <dt class="text-xs font-bold uppercase tracking-widest">Platform</dt>
                <dd class="mt-2 text-sm text-[#ccd6f6]">Android 12 and later, tuned on a Galaxy S10 and S24 Ultra</dd>
            </div>
            <div class="bg-[#0a192f] p-5">
                <dt class="text-xs font-bold uppercase tracking-widest">Stack</dt>
                <dd class="mt-2 text-sm text-[#ccd6f6]">Kotlin, Compose, sherpa-onnx, LiteRT-LM, ML Kit</dd>
            </div>
            <div class="bg-[#0a192f] p-5">
                <dt class="text-xs font-bold uppercase tracking-widest">Languages</dt>
                <dd class="mt-2 text-sm text-[#ccd6f6]">English, Chinese, Japanese, Spanish and Vietnamese, both ways</dd>
            </div>
        </dl>
    </div>

    <figure class="relative mx-auto mt-14 max-w-[420px] md:max-w-none">
        <div class="pointer-events-none absolute -inset-6 -z-10 rounded-[2.5rem] bg-amber-300/[0.06] blur-3xl" aria-hidden="true"></div>
        <#if demoReady>
        <div class="relative overflow-hidden rounded-3xl bg-black shadow-2xl shadow-black/40 ring-1 ring-white/10">
            <video id="demo-video" class="block aspect-[9/16] w-full md:aspect-video"
                   muted loop playsinline preload="metadata"
                   src="/static/media/case-studies/subly/demo-landscape.mp4"
                   poster="/static/media/case-studies/subly/demo-landscape.jpg"
                   data-landscape="/static/media/case-studies/subly/demo-landscape.mp4"
                   data-landscape-poster="/static/media/case-studies/subly/demo-landscape.jpg"
                   data-portrait="/static/media/case-studies/subly/demo-portrait.mp4"
                   data-portrait-poster="/static/media/case-studies/subly/demo-portrait.jpg"
                   aria-label="Subly demo: live translated captions over a video playing on the phone.">
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
        <#else>
        <div class="relative flex aspect-[9/16] w-full flex-col items-center justify-center gap-4 overflow-hidden rounded-3xl border border-dashed border-[#233554] bg-[#0d1f3c] px-8 text-center md:aspect-video">
            <img src="/static/media/case-studies/subly/app-icon.png" alt="" width="72" height="72" class="h-16 w-16 rounded-2xl opacity-90 shadow-lg shadow-black/40">
            <p class="text-base font-semibold text-[#ccd6f6]">Demo recording coming soon</p>
            <p class="max-w-sm text-sm leading-6">Subly is in closed testing on Google Play. A recording of the caption overlay running over a video will appear here.</p>
        </div>
        </#if>
    </figure>

    <dl class="mt-14 grid grid-cols-2 gap-x-6 gap-y-8 border-y border-[#233554] py-10 sm:grid-cols-4">
        <div>
            <dt class="text-xs font-bold uppercase tracking-widest">First translation</dt>
            <dd class="mt-2 text-4xl font-bold text-[#64ffda]">2.2 s</dd>
            <dd class="mt-1 text-sm">after speech starts, down from 11.5 s, on fast Mandarin dialogue</dd>
        </div>
        <div>
            <dt class="text-xs font-bold uppercase tracking-widest">Caption after speech</dt>
            <dd class="mt-2 text-4xl font-bold text-[#64ffda]">1.5 s</dd>
            <dd class="mt-1 text-sm">from the speaker stopping to the translated caption, down from 6.1 s</dd>
        </div>
        <div>
            <dt class="text-xs font-bold uppercase tracking-widest">Speech models measured</dt>
            <dd class="mt-2 text-4xl font-bold text-[#64ffda]">20+</dd>
            <dd class="mt-1 text-sm">on a 2019 phone, to pick one recogniser per language</dd>
        </div>
        <div>
            <dt class="text-xs font-bold uppercase tracking-widest">Audio sent off the phone</dt>
            <dd class="mt-2 text-4xl font-bold text-[#64ffda]">None</dd>
            <dd class="mt-1 text-sm">recognition and translation run locally</dd>
        </div>
    </dl>
</section>
<div class="h-16"></div>
<#elseif part == "body">

<@cs.section id="problem" number="01" title="Live captions in five languages, without the cloud">
    <p>
        A video in a language you do not speak, a lecture or a stream with no subtitles.
        Cloud services can transcribe and translate it, but that means sending everything you listen to off the phone.
    </p>
    <p>
        Subly does it on the phone itself.
        It captures the audio another app is playing, transcribes it, translates it, and draws the captions in a floating overlay on top of that app.
    </p>
    <@cs.callout label="The constraints">
        Everything on the device, with no audio leaving it.
        Captions that keep up with fast, real conversation, not just clean read speech.
        And it has to work on a 2019 phone with 8 GB of RAM, not only on this year's flagship.
    </@cs.callout>
</@cs.section>

<@cs.section id="pipeline" number="02" title="An SDK, and an app built on it">
    <p>
        The engine is a standalone Android SDK, <a href="https://github.com/pduy99/subly-android-sdk" target="_blank" rel="noreferrer" class="font-medium text-[#64ffda] hover:underline">subly-android-sdk</a>,
        with a <code class="${code}">Flow</code>-based API: a session reports its state, and captions arrive as a stream.
        The app is a thin consumer of it, with onboarding, language selection and the overlay.
        Developing them as a Gradle composite build means an SDK change shows up in the app immediately, without publishing.
    </p>
    <@cs.figure caption="The caption pipeline. Every stage is an interface, so recognisers and translators can be swapped per language and per device.">
        <ol class="grid gap-px bg-[#233554] sm:grid-cols-5">
            <#list [
                {"step": "Capture", "detail": "Audio another app is playing, through MediaProjection."},
                {"step": "Speech gate", "detail": "Silero VAD drops non-speech audio before recognition, at about 1% of real time."},
                {"step": "Recognise", "detail": "One sherpa-onnx model per language, streaming or on speech segments."},
                {"step": "Assemble", "detail": "Partial words become sentences, with punctuation restored where the model has none."},
                {"step": "Translate", "detail": "ML Kit, or Gemma 4 on LiteRT-LM on phones with enough memory."}
            ] as s>
            <li class="bg-[#0d1f3c] p-4">
                <p class="font-['JetBrains_Mono'] text-xs text-[#64ffda]">${(s?index + 1)?string["00"]}</p>
                <p class="mt-2 font-semibold text-[#ccd6f6]">${s.step}</p>
                <p class="mt-1 text-sm leading-6">${s.detail}</p>
            </li>
            </#list>
        </ol>
    </@cs.figure>
    <p>
        Model files are downloaded on first use rather than bundled, pinned to exact upstream revisions and checked against SHA-256 hashes where they come from mirrors.
        A first run downloads only the recogniser for the source language.
    </p>
</@cs.section>

<@cs.section id="recognition" number="03" title="One speech model per language, chosen by measurement" kicker="Hard part 1">
    <p>
        No single speech recogniser is good at all five languages on a phone.
        I benchmarked more than twenty candidates on the Galaxy S10, the low-end baseline, against FLEURS clips with human references,
        and picked one per language with a fixed rule:
    </p>
    <ol class="!mt-6 space-y-3">
        <#list [
            "Lowest error among models that decode at least twice as fast as real time on the S10.",
            "Prefer a streaming model within about 2 points of the best offline one, because streaming shows words as they are spoken.",
            "Among near-equals, prefer the smaller download."
        ] as rule>
        <li class="flex gap-3"><span class="font-['JetBrains_Mono'] text-xs leading-7 text-[#64ffda]">${rule?index + 1}</span><span>${rule}</span></li>
        </#list>
    </ol>
    <@cs.figure caption="The chosen recognisers. Error is from the release app on the Galaxy S10 with the clip played in a video player and captured like a user would: word error for en, es and vi, character error for zh and ja.">
        <div class="overflow-x-auto">
            <table class="w-full text-left text-sm">
                <thead>
                    <tr class="border-b border-[#233554] text-xs uppercase tracking-widest">
                        <th class="px-3 py-3 font-bold sm:px-5">Language</th>
                        <th class="px-3 py-3 font-bold sm:px-5">Model</th>
                        <th class="hidden px-3 py-3 font-bold sm:table-cell sm:px-5">Mode</th>
                        <th class="hidden px-3 py-3 text-right font-bold sm:table-cell sm:px-5">Size</th>
                        <th class="px-3 py-3 text-right font-bold sm:px-5">Error</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-[#233554]/70">
                    <#list [
                        {"l": "English", "m": "Kroko Zipformer", "mode": "streaming", "size": "71 MB", "err": "5.1%"},
                        {"l": "Chinese", "m": "Zipformer + punctuation", "mode": "streaming", "size": "243 MB", "err": "13.9%"},
                        {"l": "Japanese", "m": "ReazonSpeech k2", "mode": "on speech segments", "size": "160 MB", "err": "10.4%"},
                        {"l": "Spanish", "m": "Kroko Zipformer", "mode": "streaming", "size": "156 MB", "err": "2.2%"},
                        {"l": "Vietnamese", "m": "Zipformer 30M", "mode": "on speech segments", "size": "34 MB", "err": "9.7%"}
                    ] as r>
                    <tr>
                        <td class="px-3 py-3 font-medium text-[#ccd6f6] sm:px-5">${r.l}</td>
                        <td class="px-3 py-3 sm:px-5">${r.m}</td>
                        <td class="hidden px-3 py-3 sm:table-cell sm:px-5">${r.mode}</td>
                        <td class="hidden whitespace-nowrap px-3 py-3 text-right font-['JetBrains_Mono'] text-[13px] sm:table-cell sm:px-5">${r.size}</td>
                        <td class="whitespace-nowrap px-3 py-3 text-right font-['JetBrains_Mono'] text-[13px] text-[#64ffda] sm:px-5">${r.err}</td>
                    </tr>
                    </#list>
                </tbody>
            </table>
        </div>
    </@cs.figure>
    <p>The measurements ruled out some obvious choices:</p>
    <ul class="list-none space-y-3">
        <li class="flex gap-3"><@dot/><span><strong class="font-semibold text-[#ccd6f6]">The most accurate model was too slow.</strong> Qwen3-ASR led on several languages, but ran at 0.6 to 0.85 times real time on the S10 and is a 987 MB download.</span></li>
        <li class="flex gap-3"><@dot/><span><strong class="font-semibold text-[#ccd6f6]">A streaming model that cannot stream.</strong> Parakeet's streaming variant took 12.7 seconds to decode each second of audio on the S10.</span></li>
        <li class="flex gap-3"><@dot/><span><strong class="font-semibold text-[#ccd6f6]">Segmentation matters as much as accuracy.</strong> Offline models caption one speech segment at a time. With a short pause rule, every breath in Vietnamese became its own caption and was translated as a fragment; a 0.8 s pause made captions whole sentences and cut word error from 12.6% to 9.7%. ReazonSpeech showed the opposite: a 9.4 s segment decoded as a single word, so Japanese keeps short segments.</span></li>
    </ul>
    <p>
        Dropping the two older general-purpose engines from the app also shrank the release APK from 110.8 MB to 95.4 MB.
        They stay in the SDK for other consumers.
    </p>
</@cs.section>

<@cs.section id="translation" number="04" title="Translation that fits the phone it runs on" kicker="Hard part 2">
    <p>
        ML Kit translates a line in about 100 ms with a 30 MB model per language pair, and it runs anywhere.
        A small on-device LLM translates noticeably better: it knew that "elements" on the periodic table are chemical elements, where ML Kit chose the word for "factors".
        But the LLM is a 2.6 GB download and needs a phone with plenty of memory.
    </p>
    <p>
        So the translator depends on the device.
        On phones with 10.5 GB of RAM or more, Subly uses Gemma 4 E2B through LiteRT-LM; elsewhere it uses ML Kit.
        A handover translator prepares both at once and starts with whichever is ready first, then switches to the LLM once it has loaded.
        That turned out to matter for more than speed: ML Kit's model downloads sometimes hung for over 20 minutes with no error, and the handover kept captions working regardless.
    </p>
    <@cs.figure caption="On-device translation candidates on the Galaxy S24 Ultra GPU, 15 FLEURS sentences in 8 directions. chrF is a translation quality score against human references; higher is better.">
        <div class="overflow-x-auto">
            <table class="w-full text-left text-sm">
                <thead>
                    <tr class="border-b border-[#233554] text-xs uppercase tracking-widest">
                        <th class="px-3 py-3 font-bold sm:px-5">Model</th>
                        <th class="px-3 py-3 text-right font-bold sm:px-5">chrF</th>
                        <th class="px-3 py-3 text-right font-bold sm:px-5">First token</th>
                        <th class="px-3 py-3 text-right font-bold sm:px-5">Sentence</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-[#233554]/70 font-['JetBrains_Mono'] text-[12px] sm:text-[13px]">
                    <tr>
                        <td class="px-3 py-3 font-['Inter'] text-sm sm:px-5">Qwen3-4B <span class="text-[#6b7a99]">(before)</span></td>
                        <td class="px-3 py-3 text-right sm:px-5">48.5</td>
                        <td class="whitespace-nowrap px-3 py-3 text-right sm:px-5">2,210 ms</td>
                        <td class="whitespace-nowrap px-3 py-3 text-right sm:px-5">5,271 ms</td>
                    </tr>
                    <tr class="bg-[#64ffda]/[0.05]">
                        <td class="px-3 py-3 font-['Inter'] text-sm font-medium text-[#64ffda] sm:px-5">Gemma 4 E2B <span class="ml-1 rounded-full bg-[#64ffda]/10 px-2 py-0.5 text-[11px] font-semibold">chosen</span></td>
                        <td class="px-3 py-3 text-right text-[#ccd6f6] sm:px-5">50.0</td>
                        <td class="whitespace-nowrap px-3 py-3 text-right text-[#ccd6f6] sm:px-5">380 ms</td>
                        <td class="whitespace-nowrap px-3 py-3 text-right text-[#ccd6f6] sm:px-5">1,641 ms</td>
                    </tr>
                    <tr>
                        <td class="px-3 py-3 font-['Inter'] text-sm sm:px-5">Hy-MT2 1.8B</td>
                        <td class="px-3 py-3 text-right sm:px-5">49.7</td>
                        <td class="whitespace-nowrap px-3 py-3 text-right sm:px-5">1,089 ms</td>
                        <td class="whitespace-nowrap px-3 py-3 text-right sm:px-5">3,802 ms</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </@cs.figure>
    <p>
        Gemma 4 E2B matched or beat the previous model in 6 of 8 directions and was 3.2 times faster per sentence.
        Turning on its multi-token prediction drafter made sentences another 19% faster at the same quality, well short of the "up to 2.2x" headline, which was measured on a newer phone.
    </p>
</@cs.section>

<@cs.section id="realtime" number="05" title="From 11.5 seconds to 2.2" kicker="Hard part 3">
    <p>
        The first full pipeline was accurate but late.
        On fast Mandarin dialogue translated to Vietnamese, the first translated words appeared 11.5 seconds after a sentence started.
        A per-caption latency tracker showed three causes, in order of size:
    </p>
    <ol class="!mt-6 space-y-4">
        <li class="rounded-xl border border-[#233554] bg-[#0d1f3c] p-5">
            <p class="font-semibold text-[#ccd6f6]"><span class="mr-2 font-['JetBrains_Mono'] text-xs text-[#64ffda]">01</span>The translator was slow</p>
            <p class="mt-1 text-sm leading-6">Lines arrived faster than the old model could translate them, so they queued. Moving to Gemma 4 E2B fixed most of it.</p>
        </li>
        <li class="rounded-xl border border-[#233554] bg-[#0d1f3c] p-5">
            <p class="font-semibold text-[#ccd6f6]"><span class="mr-2 font-['JetBrains_Mono'] text-xs text-[#64ffda]">02</span>Sentences were committed late</p>
            <p class="mt-1 text-sm leading-6">Nobody in a fast dialogue pauses for 0.8 s, so the recogniser only finished a sentence at its 10 s cap. An early committer now takes a sentence from the live hypothesis once it is complete, followed by more speech, and unchanged for about 0.4 s.</p>
        </li>
        <li class="rounded-xl border border-[#233554] bg-[#0d1f3c] p-5">
            <p class="font-semibold text-[#ccd6f6]"><span class="mr-2 font-['JetBrains_Mono'] text-xs text-[#64ffda]">03</span>Nothing was translated while someone spoke</p>
            <p class="mt-1 text-sm leading-6">A live preview now translates the sentence still being spoken whenever the translator is idle, and is cancelled the moment committed work needs it.</p>
        </li>
    </ol>
    <@cs.figure caption="Release app on a Galaxy S24 Ultra, fast Mandarin dialogue to Vietnamese, medians. Before: Qwen3-4B, no early commit, no live preview. After: Gemma 4 E2B with both.">
        <div class="space-y-6 p-5 sm:p-6" role="img" aria-label="Median time from speech starting to the first translated words fell from 11.5 to 2.2 seconds. Median time from speech stopping to the translated caption fell from 6.1 to 1.5 seconds.">
            <#list [
                {"label": "Speech starts to first translated words", "before": 11531, "after": 2170},
                {"label": "Speech stops to translated caption", "before": 6086, "after": 1548}
            ] as m>
            <div>
                <p class="text-sm font-semibold text-[#ccd6f6]">${m.label}</p>
                <div class="mt-3 space-y-2">
                    <div class="flex items-center gap-3">
                        <span class="w-12 shrink-0 text-xs">Before</span>
                        <div class="h-3 rounded-r bg-[#64748b]" style="width: ${(m.before / 11531 * 80)?c}%;" title="Before: ${(m.before / 1000)?string["0.0"]} s"></div>
                        <span class="shrink-0 font-['JetBrains_Mono'] text-xs text-[#ccd6f6]">${(m.before / 1000)?string["0.0"]} s</span>
                    </div>
                    <div class="flex items-center gap-3">
                        <span class="w-12 shrink-0 text-xs">After</span>
                        <div class="h-3 rounded-r bg-[#64ffda]" style="width: ${(m.after / 11531 * 80)?c}%;" title="After: ${(m.after / 1000)?string["0.0"]} s"></div>
                        <span class="shrink-0 font-['JetBrains_Mono'] text-xs text-[#ccd6f6]">${(m.after / 1000)?string["0.0"]} s</span>
                    </div>
                </div>
            </div>
            </#list>
        </div>
    </@cs.figure>
    <@cs.callout label="Measured, then kept off" tone="amber">
        Translating each clause as it arrives sounded like an obvious win.
        Measured twice, with two different models, it made captions later: draft translations queued in front of finished sentences.
        It stays in the SDK, switched off, with the numbers in its documentation.
    </@cs.callout>
</@cs.section>

<@cs.section id="measuring" number="06" title="Measuring on real phones">
    <p>
        Every model choice and default in Subly comes from a measurement, and the numbers live next to the code that depends on them.
        A dedicated benchmark module, never shipped, runs on physical phones:
        a 2019 Galaxy S10 with 8 GB as the low-end baseline and a Galaxy S24 Ultra with 12 GB.
    </p>
    <ul class="list-none space-y-3">
        <li class="flex gap-3"><@dot/><span><strong class="font-semibold text-[#ccd6f6]">A real test set.</strong> FLEURS clips in all five languages with human references, plus a real recording of fast Mandarin dialogue, scored by word or character error.</span></li>
        <li class="flex gap-3"><@dot/><span><strong class="font-semibold text-[#ccd6f6]">Tested the way users run it.</strong> The final numbers come from the release app with a clip playing in a video player and captured through MediaProjection, not from feeding audio files straight into the engine.</span></li>
        <li class="flex gap-3"><@dot/><span><strong class="font-semibold text-[#ccd6f6]">Honest comparisons.</strong> The S24 throttles after about an hour of GPU work, so A/B runs alternate on and off back to back. A control run caught a speech-gate change that had quietly moved more than a third of caption starts, and it was fixed.</span></li>
    </ul>
</@cs.section>

<@cs.section id="privacy" number="07" title="Private by design">
    <p>
        Audio is held only in short-lived memory buffers while it is processed, and captions are cleared shortly after they stop updating.
        Nothing is written to storage and no audio or text is sent anywhere.
        Even the benchmark logs only print transcripts when verbose logging is switched on explicitly, because transcripts are the user's speech.
    </p>
    <p>
        Android asks for consent each time capture starts and shows a notification for as long as it runs.
        The network is used to download models and to send diagnostics, which the privacy policy spells out.
    </p>
</@cs.section>

<@cs.section id="status" number="08" title="Status and next steps">
    <ul class="list-none space-y-3">
        <li class="flex gap-3"><@dot/><span>In closed testing on Google Play, captioning and translating between English, Chinese, Japanese, Spanish and Vietnamese.</span></li>
        <li class="flex gap-3"><@dot/><span>Japanese and Vietnamese use offline recognisers, so their source text appears about 2.5 s into a sentence, against about 0.5 s for the streaming languages. That is the next latency gap to close.</span></li>
        <li class="flex gap-3"><@dot/><span>Gemma 4 E2B has not yet been measured on 8 GB phones. If it fits, it could replace ML Kit on the S10 class of device too.</span></li>
        <li class="flex gap-3"><@dot/><span>Recognisers are chosen per language today; choosing them per device class, as translation already is, would let 12 GB phones use the most accurate model.</span></li>
    </ul>
    <p class="text-xs text-[#6b7a99]">Numbers measured in October 2026.</p>
</@cs.section>

</#if>
</@cs.page>
