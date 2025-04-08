<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${profile.name}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Add Inter font -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .spotlight {
            position: fixed;
            inset: 0;
            z-index: 30;
            pointer-events: none;
            background: radial-gradient(
                600px circle at var(--x) var(--y),
                rgba(29, 78, 216, 0.15),
                transparent 80%
            );
        }
        .active .nav-indicator {
            width: 4rem;
            --tw-bg-opacity: 1;
            background-color: rgb(226 232 240/var(--tw-bg-opacity));
        }

        .active .nav-text {
            --tw-text-opacity: 1;
            color: rgb(226 232 240/var(--tw-text-opacity));
        }
    </style>
</head>
<body class="bg-[#0a192f] text-[#8892b0] font-['Inter']">
    <div id="spotlight" class="spotlight"></div>
    <div class="mx-auto min-h-screen max-w-screen-xl px-6 py-12 md:px-12 md:py-20 lg:px-24 lg:py-0">
        <div class="lg:flex lg:justify-between lg:gap-4">
            <!-- Left Column -->
            <header class="lg:sticky lg:top-0 lg:flex lg:max-h-screen lg:w-1/2 lg:flex-col lg:justify-between lg:py-24">
                <div>
                    <h1 class="text-4xl font-bold text-[#ccd6f6] sm:text-5xl">
                        ${profile.name}
                    </h1>
                    <h2 class="mt-3 text-lg font-medium text-[#a8b2d1] sm:text-xl">
                        ${profile.title}
                    </h2>
                    <p class="mt-4 max-w-xs text-[#8892b0]">${profile.about}</p>

                    <!-- Navigation -->
                    <nav class="nav hidden lg:block" aria-label="In-page jump links">
                        <ul class="mt-16 w-max">
                            <#list profile.sections as section>
                            <li>
                                <a class="group flex items-center py-3 ${section.active?then('active', '')}" href="#${section.id}">
                                    <span class="nav-indicator mr-4 h-px w-8 bg-[#233554] transition-all group-hover:w-16 group-hover:bg-[#64ffda]"></span>
                                    <span class="nav-text text-xs font-bold uppercase tracking-widest text-[#8892b0] group-hover:text-[#64ffda]">
                                        ${section.name}
                                    </span>
                                </a>
                            </li>
                            </#list>
                        </ul>
                    </nav>
                </div>

                <!-- Social Links -->
                <ul class="ml-1 mt-8 flex items-center">
                    <#list profile.social as link>
                        <li class="mr-5">
                            <a class="block hover:text-[#64ffda] text-[#8892b0]" href="${link.url}" target="_blank" rel="noreferrer">
                                <#if link.name == "GitHub">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="h-6 w-6">
                                        <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/>
                                    </svg>
                                <#elseif link.name == "LinkedIn">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="h-6 w-6">
                                        <path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z"/>
                                    </svg>
                                <#elseif link.name == "Instagram">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="h-6 w-6">
                                        <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z"/>
                                    </svg>
                                <#else>
                                    <!-- Default icon or text fallback -->
                                    <span class="text-sm">${link.name}</span>
                                </#if>
                            </a>
                        </li>
                    </#list>
                </ul>
            </header>

            <!-- Main Content -->
            <main class="pt-24 lg:w-[52%] lg:py-24">
                <!-- About Section -->
                <section id="about" class="mb-16 scroll-mt-16 md:mb-24 lg:mb-36 lg:scroll-mt-24">
                    <div class="sticky top-0 z-20 -mx-6 mb-4 w-screen bg-slate-900/75 px-6 py-5 backdrop-blur md:-mx-12 md:px-12 lg:sr-only lg:relative lg:top-auto lg:mx-auto lg:w-full lg:px-0 lg:py-0 lg:opacity-0">
                        <h2 class="text-sm font-bold uppercase tracking-widest text-slate-200 lg:sr-only">About</h2>
                    </div>
                    <div>
                        <#list content.about.paragraphs as paragraph>
                            <p class="mb-4">${paragraph}</p>
                        </#list>
                    </div>
                </section>

                <!-- Experience Section -->
                <section id="experience" class="mb-16 scroll-mt-16 md:mb-24 lg:mb-36 lg:scroll-mt-24">
                    <div class="sticky top-0 z-20 -mx-6 mb-4 w-screen bg-slate-900/75 px-6 py-5 backdrop-blur md:-mx-12 md:px-12 lg:sr-only lg:relative lg:top-auto lg:mx-auto lg:w-full lg:px-0 lg:py-0 lg:opacity-0">
                        <h2 class="text-sm font-bold uppercase tracking-widest text-slate-200 lg:sr-only">Experience</h2>
                    </div>
                    <ol class="group/list">
                        <#list content.experience as exp>
                        <li class="mb-12">
                            <div class="group relative grid pb-1 transition-all sm:grid-cols-8 sm:gap-8 md:gap-4 lg:hover:!opacity-100 lg:group-hover/list:opacity-50 cursor-pointer">
                                <div class="absolute -inset-x-4 -inset-y-4 z-0 hidden rounded-md transition motion-reduce:transition-none lg:-inset-x-6 lg:block lg:group-hover:bg-slate-800/50 lg:group-hover:shadow-[inset_0_1px_0_0_rgba(148,163,184,0.1)] lg:group-hover:drop-shadow-lg"></div>
                                <header class="z-10 mb-2 mt-1 text-xs font-semibold uppercase tracking-wide text-slate-500 sm:col-span-2">${exp.dateRange}</header>
                                <div class="z-10 sm:col-span-6">
                                    <h3 class="font-medium leading-snug text-slate-200">
                                        <div>${exp.title} · <a href="${exp.companyUrl}" target="_blank" rel="noreferrer" class="text-slate-200 hover:text-[#64ffda]">${exp.company}</a></div>
                                    </h3>
                                    <p class="mt-2 text-sm leading-normal">${exp.description}</p>
                                    <ul class="mt-2 flex flex-wrap" aria-label="Technologies used">
                                        <#list exp.technologies as tech>
                                        <li class="mr-1.5 mt-2">
                                            <div class="flex items-center rounded-full bg-teal-400/10 px-3 py-1 text-xs font-medium leading-5 text-[#64ffda]">${tech.name}</div>
                                        </li>
                                        </#list>
                                    </ul>
                                </div>
                            </div>
                        </li>
                        </#list>
                    </ol>
                    <div class="mt-12">
                        <a class="inline-flex items-baseline font-medium leading-tight text-slate-200 hover:text-[#64ffda] focus-visible:text-[#64ffda] font-semibold text-slate-200 group/link text-base" href="/resume" target="_blank" rel="noreferrer">
                            <span>
                                View Full
                                <span class="inline-block">
                                    Résumé
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="inline-block h-4 w-4 shrink-0 transition-transform group-hover/link:-translate-y-1 group-hover/link:translate-x-1 group-focus-visible/link:-translate-y-1 group-focus-visible/link:translate-x-1 motion-reduce:transition-none ml-1 translate-y-px">
                                        <path fill-rule="evenodd" d="M5.22 14.78a.75.75 0 001.06 0l7.22-7.22v5.69a.75.75 0 001.5 0v-7.5a.75.75 0 00-.75-.75h-7.5a.75.75 0 000 1.5h5.69l-7.22 7.22a.75.75 0 000 1.06z" clip-rule="evenodd" />
                                    </svg>
                                </span>
                            </span>
                        </a>
                    </div>
                </section>

                <!-- Projects Section -->
                <section id="projects" class="mb-16 scroll-mt-16 md:mb-24 lg:mb-36 lg:scroll-mt-24">
                    <div class="sticky top-0 z-20 -mx-6 mb-4 w-screen bg-slate-900/75 px-6 py-5 backdrop-blur md:-mx-12 md:px-12 lg:sr-only lg:relative lg:top-auto lg:mx-auto lg:w-full lg:px-0 lg:py-0 lg:opacity-0">
                        <h2 class="text-sm font-bold uppercase tracking-widest text-slate-200 lg:sr-only">Projects</h2>
                    </div>
                    <ul class="group/list">
                        <#list content.projects as project>
                        <li class="mb-12">
                            <div class="group relative grid gap-4 pb-1 transition-all sm:grid-cols-8 sm:gap-8 md:gap-4 lg:hover:!opacity-100 lg:group-hover/list:opacity-50 cursor-pointer">
                                <div class="absolute -inset-x-4 -inset-y-4 z-0 hidden rounded-md transition motion-reduce:transition-none lg:-inset-x-6 lg:block lg:group-hover:bg-slate-800/50 lg:group-hover:shadow-[inset_0_1px_0_0_rgba(148,163,184,0.1)] lg:group-hover:drop-shadow-lg"></div>
                                <#if project.imageUrl?has_content>
                                    <img alt="${project.name}" loading="lazy" width="200" height="48" decoding="async" class="relative z-10 aspect-video object-cover rounded border-2 border-slate-200/10 transition group-hover:border-slate-200/30 sm:order-1 sm:col-span-2 sm:translate-y-1" src="${project.imageUrl}"/>
                                    <div class="z-10 sm:order-2 sm:col-span-6">
                                <#else>
                                    <div class="z-10 sm:col-span-8">
                                </#if>
                                    <h3>
                                        <a class="inline-flex items-baseline font-medium leading-tight text-slate-200 hover:text-[#64ffda] focus-visible:text-[#64ffda] group/link text-base" href="${project.url}" target="_blank" rel="noreferrer">
                                            <span>
                                                ${project.name}
                                                <span class="inline-block">
                                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="inline-block h-4 w-4 shrink-0 transition-transform group-hover/link:-translate-y-1 group-hover/link:translate-x-1 group-focus-visible/link:-translate-y-1 group-focus-visible/link:translate-x-1 motion-reduce:transition-none ml-1 translate-y-px">
                                                        <path fill-rule="evenodd" d="M5.22 14.78a.75.75 0 001.06 0l7.22-7.22v5.69a.75.75 0 001.5 0v-7.5a.75.75 0 00-.75-.75h-7.5a.75.75 0 000 1.5h5.69l-7.22 7.22a.75.75 0 000 1.06z" clip-rule="evenodd" />
                                                    </svg>
                                                </span>
                                            </span>
                                        </a>
                                    </h3>
                                    <p class="mt-2 text-sm leading-normal">${project.description}</p>
                                    <#if project.stars??>
                                        <div class="mt-2 text-sm font-medium text-slate-400">⭐ ${project.stars}</div>
                                    </#if>
                                    <#if project.technologies?has_content>
                                        <ul class="mt-2 flex flex-wrap" aria-label="Technologies used">
                                            <#list project.technologies as tech>
                                            <li class="mr-1.5 mt-2">
                                                <div class="flex items-center rounded-full bg-teal-400/10 px-3 py-1 text-xs font-medium leading-5 text-[#64ffda]">${tech.name}</div>
                                            </li>
                                            </#list>
                                        </ul>
                                    </#if>
                                </div>
                            </div>
                        </li>
                        </#list>
                    </ul>
                </section>
            </main>
        </div>
    </div>
    <!-- Add credit footer -->
    <footer class="max-w-screen-xl mx-auto px-6 pb-8 text-center text-xs text-slate-500">
        <p>
            Inspired by
            <a href="https://brittanychiang.com" target="_blank" rel="noreferrer" class="text-slate-400 hover:text-[#64ffda]">
                brittanychiang.com
            </a>
        </p>
    </footer>
    <script src="static/js/main.js"></script>
</body>
</html>