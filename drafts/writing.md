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
methodology thanks to [Kevin Powell](https://www.youtube.com/@KevinPowell)'s
amazing video called [A look at the CUBE CSS methodology in action](https://youtu.be/NanhQvnvbR8).

The reason why I chose CUBE CSS is because its website mentions:

- _"CUBE CSS is a CSS methodology that's orientated towards simplicity,
pragmatism and consistency."_
- _"This differs somewhat to other popular methodologies like BEM, which are
very good in their own right, but also run against the grain of CSS."_

Those made me want to explore and experiment it.

It turns out that using  CUBE CSS has been a fun experience, even though I
initially had a hard time to understand what Block is and when Block should be
used.

### CSS Reset

I referenced Josh Comeau's [CSS Reset](https://www.joshwcomeau.com/css/custom-css-reset).
His CSS reset is solid, simple, and sufficient in most cases. If you get a
chance, I highly recommend checking it out. He explains it in great detail.

### Code syntax highlighting

I copied Pandoc's [syntax highlighting style](https://pandoc.org/try/?params=%7B%22text%22%3A%22---%5Cntitle%3A+Code+with+syntax+highlighting%5Cnlang%3A+en-US%5Cn...%5Cn%5CnHere%27s+some+code+with+syntax+highlighting%3A%5Cn%5Cn%60%60%60+haskell%5Cn--+%7C+Inefficient+quicksort+in+haskell.%5Cnqsort+%3A%3A+%28Enum+a%29+%3D%3E+%5Ba%5D+-%3E+%5Ba%5D%5Cnqsort+%5B%5D+++++%3D+%5B%5D%5Cnqsort+%28x%3Axs%29+%3D+qsort+%28filter+%28%3C+x%29+xs%29+%2B%2B+%5Bx%5D+%2B%2B%5Cn+++++++++++++++qsort+%28filter+%28%3E%3D+x%29+xs%29+%5Cn%60%60%60%5Cn%5CnTry+changing+the+highlighting+style+to+see+what+effect+this+has.%5Cn%5CnHere%27s+some+python%2C+with+numbered+lines%3A%5Cn%5Cn%60%60%60+python+%7B.numberLines%7D%5Cnclass+FSM%28object%29%3A%5Cn%5Cn%5C%22%5C%22%5C%22This+is+a+Finite+State+Machine+%28FSM%29.%5Cn%5C%22%5C%22%5C%22%5Cn%5Cndef+__init__%28self%2C+initial_state%2C+memory%3DNone%29%3A%5Cn%5Cn++++%5C%22%5C%22%5C%22This+creates+the+FSM.+You+set+the+initial+state+here.+The+%5C%22memory%5C%22%5Cn++++attribute+is+any+object+that+you+want+to+pass+along+to+the+action%5Cn++++functions.+It+is+not+used+by+the+FSM.+For+parsing+you+would+typically%5Cn++++pass+a+list+to+be+used+as+a+stack.+%5C%22%5C%22%5C%22%5Cn%5Cn++++%23+Map+%28input_symbol%2C+current_state%29+--%3E+%28action%2C+next_state%29.%5Cn++++self.state_transitions+%3D+%7B%7D%5Cn++++%23+Map+%28current_state%29+--%3E+%28action%2C+next_state%29.%5Cn++++self.state_transitions_any+%3D+%7B%7D%5Cn++++self.default_transition+%3D+None%5Cn++++...%5Cn%60%60%60%5Cn%22%2C%22to%22%3A%22html%22%2C%22from%22%3A%22markdown%22%2C%22standalone%22%3Atrue%2C%22embed-resources%22%3Afalse%2C%22table-of-contents%22%3Afalse%2C%22number-sections%22%3Afalse%2C%22citeproc%22%3Afalse%2C%22html-math-method%22%3A%22plain%22%2C%22wrap%22%3A%22preserve%22%2C%22highlight-style%22%3A%22kate%22%2C%22files%22%3A%7B%7D%2C%22template%22%3Anull%7D),
then adjusted and improved it to align with my preferences. My CSS style for
syntax highlighting can be found [here](https://github.com/namvnngu/namvnngu.github.io/blob/main/src/styles/code.css).
It supports both light and dark mode.

For example:

- C

``` c {.number-lines}
#include <stdio.h>

int main(void) {
  printf("Hello world!");
}
```

- JavaScript

``` javascript {.number-lines}
const express = require('express')
const app = express()
const port = 3000

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
```

[&#8593; Back to top](#TOC)

## Content

[&#8593; Back to top](#TOC)

### How is page content managed?

Repeated HTML blocks

[&#8593; Back to top](#TOC)

### How is piece of writing like this created?

[&#8593; Back to top](#TOC)

## Interesting points during development

[&#8593; Back to top](#TOC)
