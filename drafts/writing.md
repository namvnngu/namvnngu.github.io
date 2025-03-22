---
title: How Did I Build My Website?
lang: en
...

## Motivation

In the past, I built some portfolios to mainly showcase my small projects
when I was learning programming and job hunting. These portfolios were unnecessarily
complex, built with [React.js](https://react.dev) or [Next.js](https://nextjs.org).
The most recent one can be found [here](https://vnngu.vercel.app/). After landing
my first programming job, I neglected the portfolio, neither updating it nor
writing any blog posts. At the beginning of 2025, I decided to make a "fresh start"
by rebuilding my website with a simpler UI and without any JavaScript front-end
frameworks/libraries.

As I have grown in my programming career, I have become more interested in
understanding how technologies work under the hood and sharing my thoughts on
topics that intrigue me. This new website will become a space for both exploration
and writing.

The source code of my website can be found [here](https://github.com/namvnngu/namvnngu.github.io).

[&#8593; Back to top](#TOC)

## Tech stack

Here are the major technologies I have used to build my website:

- [HTML](https://developer.mozilla.org/en-US/docs/Web/HTML) defines the website's
structure and content.
- [CSS](https://developer.mozilla.org/en-US/docs/Web/CSS) specifies the website's
styling.
- [GNU Bash](https://www.gnu.org/software/bash) defines scripts for building
the website, deploying the website and updating repeated HTML blocks across pages.
- [GNU Make](https://www.gnu.org/software/make) defines custom commands and
automates repeated tasks such as running a development server, building the website,
deploying the website, and cleaning up.
- [GNU sed](https://www.gnu.org/software/sed) updates repeated HTML blocks.
- [Pandoc](https://pandoc.org) converts Markdown to HTML.
- [GitHub Pages](https://pages.github.com) hosts the website.

[&#8593; Back to top](#TOC)

## Styling

### CSS methodology

There are many CSS methodologies to architect, manage and maintain a website's
styling, such as BEM, OOCSS, SMACSS, Atomic CSS, ITCSS or CUBE CSS. Eventually,
I chose [CUBE CSS](https://cube.fyi). CUBE stands for Composition Utility Block
Exception, and obviously, CSS stands for Cascading Style Sheets. I knew this
methodology thanks to [Kevin Powell](https://www.youtube.com/@KevinPowell) via
his video called [A look at the CUBE CSS methodology in action](https://youtu.be/NanhQvnvbR8).

The reason why I chose CUBE CSS is because its website mentions that _"CUBE CSS
is a CSS methodology that's orientated towards simplicity, pragmatism and
consistency."_, and _"This differs somewhat to other popular methodologies like
BEM, which are very good in their own right, but also run against the grain of
CSS."_, which made me want to explore and experiment it.

It turns out that working with CUBE CSS has been a fun experience, even though
I initially had a hard time to understand what Block is and when Block should
be used.

### CSS Reset

### Code syntax highlighting

Copy, adjust and improve to be what I prefer.

[&#8593; Back to top](#TOC)

## Content

[&#8593; Back to top](#TOC)

### How is page content managed?

Repeated HTML block

[&#8593; Back to top](#TOC)

### How is piece of writing like this created?

[&#8593; Back to top](#TOC)

## Interesting points during development

[&#8593; Back to top](#TOC)
