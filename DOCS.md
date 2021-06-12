# Table of content

1. [Settings](#settings)
   1. [Global settings](#global-settings)
   2. [Agenda settings](#global-settings)
   3. [Tags settings](#global-settings)
2. [Mappings](#mappings)
   1. [Global Mappings](#global-mappings)
   2. [Agenda Mappings](#agenda-mappings)
   3. [Capture Mappings](#capture-mappings)
   4. [Org Mappings](#org-mappings)

## Settings
Variable names mostly follow the same naming as Orgmode mappings.
Biggest difference is that underscores are being used instead of hyphens.

[Link to all settings file](lua/orgmode/config/defaults.lua)


### Global settings

#### **org_agenda_files**
*type*: `string|string[]`<br />
*default value*: `''`<br />
Glob path where agenda files are read from. Can provide multiple paths via array.<br />
Examples:
  * `'~/Dropbox/org/*'`,
  * `{'~/Dropbox/org/*', '~/my-orgs/**/*'}`

#### **org_default_notes_file**
*type*: `string`<br />
*default value*: `''`<br />
Path to a file that will be used as a default target file when refiling<br />
Example: `~/Dropbox/org/notes.org`

#### **org_todo_keywords**
*type*: `string[]`<br />
*default value*: `{'TODO', '|', 'DONE'}`<br />
List of "unfinished" and "finished" states.<br />
`|` is used as a separator between "unfinished" and "finished".<br />
If `|` is omitted, only last entry in array is considered a "finished" state.<br />
Examples:
  * `{'TODO', 'NEXT', '|', 'DONE'}`
  * `{'TODO', 'WAITING', '|', 'DONE', 'DELEGATED'}`

#### **org_archive_location**
*type*: `string`<br />
*default value*: `'%s_archive::'`<br />
Destination file for archiving. `%s` indicates the current file. `::` is used as a separator for archiving to headline<br />
which is currently not supported.<br />
This means that if you do a refile from a file `~/my-orgs/todos.org`, your task<br />
will be archived in `~/my-orgs/todos.org_archive`.<br />
Example values:
  * `'~/my-orgs/default-archive-file.org::'`
This value can be overridden per file basis with a org special keyword `#+ARCHIVE`.<br />
  Example: `#+ARCHIVE: ~/path/to/archive_file.org`

### Agenda settings

#### **org_deadline_warning_days**
*type*: `number`,<br />
*default value*: `14`<br />
Number of days during which deadline becomes visible in today's agenda.<br />
Example:
  If Today is `2021-06-10`, and we have these tasks:<br />
  `Task 1` has a deadline date `2021-06-15`<br />
  `Task 2` has a deadline date `2021-06-30`<br />
  <br />
  `Task 1` is visible in today's agenda<br />
  `Task 2` is not visible in today's agenda until `2021-06-16`

#### **org_agenda_span**
*type*: `string|number`<br />
*default value*: 'week'<br />
*possible string values*: `day`, `week`, `month`, `year`<br />
Default time span shown when agenda is opened.

#### **org_agenda_start_on_weekday**
*type*: `number`<br />
*default value*: `1`<br />
From which day in week (ISO weekday, 1 is Monday) to show the agenda. Applies only to `week` and number span.<br />
If set to `nil`, starts from today

#### **org_agenda_start_day**
*type*: 'string'<br />
*default value*: `nil`<br />
*example values*: `+2d`, `-1d`<br />
offset to apply to the agenda start date.<br />
Example:<br />
  If `org_agenda_start_on_weekday` is `nil`, and `org_agenda_start_day` is `-2d`,<br />
  agenda will always show current week from today - 2 days

#### **org_agenda_templates**
*type*: `table<string, table>`<br />
default value: `{ t = { description: 'Task', template: '* TODO %?\n  %u' } }`<br />
Templates for capture/refile prompt.<br />
Variables:
  * `%t`: Prints current date (Example: `<2021-06-10 Thu>`) `%T`: Prints current date and time (Example: `<2021-06-10 Thu 12:30>`)
  * `%u`: Prints current date in inactive format (Example: `[2021-06-10 Thu]`)
  * `%U`: Prints current date and time in inactive format (Example: `[2021-06-10 Thu 12:30]`)
  * `%?`: Default cursor position when template is opened

#### **org_priority_highest**
*type*: `string|number`<br />
*default value*: `A`<br />
Indicates highest priority for a task in the agenda view.<br />
Example:<br />
  `* TODO [#A] This task has the highest priority`

#### **org_priority_default**
*type*: `string|number`<br />
*default value*: `B`<br />
Indicates normal priority for a task in the agenda view.<br />
This is the default priority for all tasks if other priority is not applied<br />
Example:<br />
  `* TODO [#B] This task has the normal priority`<br />
  `* TODO And this one has the same priority`

#### **org_priority_lowest**
*type*: `string|number`<br />
*default value*: `C`<br />
Indicates lowest priority for a task in the agenda view.<br />
Example:<br />
  `* TODO [#B] This task has the normal priority`<br />
  `* TODO And this one has the same priority`<br />
  `* TODO [#C] I'm lowest in priority`

### Tags settings

#### **org_use_tag_inheritance**
*type*: `boolean`
*default value*: `true`
When set to `true`, tags are inherited from parents for purposes of searching. Which means that if you have this structure:
```
* TODO My top task :MYTAG:
** TODO MY child task :CHILDTAG:
*** TODO Nested task
```
First headline has tag `MYTAG`
Second headline has tags `MYTAG` and `CHILDTAG`
Third headline has tags `MYTAG` and `CHILDTAG`
When disabled, headlines have only tags that are directly applied to them.

#### **org_tags_exclude_from_inheritance**
*type*: `string[]`<br />
*default value*: `{}`<br />
List of tags that are excluded from inheritance.<br />
Using the example above, setting this variable to `{'MYTAG'}`, second and third headline would have only `CHILDTAG`, where `MYTAG` would not be inherited.<br />

## Mappings

Mappings try to mimic some of the Orgmode mappings, but since Orgmode uses `CTRL + c` as a modifier most of the time, we have to take a different route.
When possible, instead of `CTRL + C`, prefix `<Leader>o` is used.

To disable all mappings, just pass `disable_all = true` to mappings settings:
```lua
require('orgmode').setup({
  org_agenda_file = {'~/Dropbox/org/*', '~/my-orgs/**/*'},
  org_default_notes_file = '~/Dropbox/org/refile.org',
  mappings = {
    disable_all = true
  }
})
```

**NOTE**: All mappings are normal mode mappings (`nnoremap`)

### Global mappings

There are only 2 global mappings that are accessible from everywhere.

#### **org_agenda**
*mapped to*:  <kbd>\<Leader\>oa</kbd><br />
Opens up agenda prompt.

#### **org_capture**
*mapped to*:  `<Leader>oc`<br />
Opens up capture prompt.

These live under `mappings.global` and can be overridden like this:

```lua
require('orgmode').setup({
  org_agenda_file = {'~/Dropbox/org/*', '~/my-orgs/**/*'},
  org_default_notes_file = '~/Dropbox/org/refile.org',
  mappings = {
    global = {
      org_agenda = 'gA',
      org_capture = 'gC'
    }
  }
})
```

If you want to use multiple mappings for same thing, pass array of mappings:

```lua
require('orgmode').setup({
  org_agenda_file = {'~/Dropbox/org/*', '~/my-orgs/**/*'},
  org_default_notes_file = '~/Dropbox/org/refile.org',
  mappings = {
    global = {
      org_agenda = {'gA', '<Leader>oa'},
      org_capture = {'gC', '<Leader>oc'}
    }
  }
})
```

### Agenda mappings

Mappings used in agenda view window.

#### **org_agenda_later**
*mapped to*: `f`
Go to next agenda span
#### **org_agenda_earlier**
*mapped to*: `b`
Go to previous agenda span
#### **org_agenda_goto_today**
*mapped to*: `.`
Go to span with for today
#### **org_agenda_day_view **
*mapped to*: `vd`
Show agenda day view
#### **org_agenda_week_view**
*mapped to*: `vw`
Show agenda week view
#### **org_agenda_month_view**
*mapped to*: `vm`
Show agenda month view
#### **org_agenda_year_view**
*mapped to*: `vy`
Show agenda year view
#### **org_agenda_quit**
*mapped to*: `q`
Close agenda
#### **org_agenda_switch_to**
*mapped to*: `<CR>`
Open selected agenda item in the same buffer
#### **org_agenda_goto**
*mapped to*: `{'<TAB>'}`
Open selected agenda item in split window
#### **org_agenda_goto_date**
*mapped to*: `J`
Open calendar that allows selecting date to jump to
#### **org_agenda_redo**
*mapped to*: `r`
Reload all org files and refresh current agenda view

These mappings live under `mappings.agenda`, and can be changed like this:

```lua
require('orgmode').setup({
  org_agenda_file = {'~/Dropbox/org/*', '~/my-orgs/**/*'},
  org_default_notes_file = '~/Dropbox/org/refile.org',
  mappings = {
    agenda = {
      org_agenda_later = '>',
      org_agenda_earlier = '<',
      org_agenda_goto_today = {'.', 'T'}
    }
  }
})
```

### Capture mappings

Mappings used in capture window.

#### **org_capture_finalize**
*mapped to*: `<C-c>`
Save current capture content to `org_default_notes_file` and close capture window
#### **org_capture_refile**
*mapped to*: `<Leader>or`
Refile capture content to specific destination
#### **org_capture_kill**
*mapped to*: `<Leader>ok`
Close capture window without saving anything

These mappings live under `mappings.capture`, and can be changed like this:

```lua require('orgmode').setup({
  org_agenda_file = {'~/Dropbox/org/*', '~/my-orgs/**/*'},
  org_default_notes_file = '~/Dropbox/org/refile.org',
  mappings = {
    capture = {
      org_capture_finalize = '<Leader>w',
      org_capture_refile = 'R',
      org_capture_kill = 'Q'
    }
  }
})
```

### Org mappings

Mappings for `org` files.
#### **org_refile**
*mapped to*: `<Leader>or`
Refile current headline to destination
#### **org_increase_date**
*mapped to*: `<C-a>`
Increase date under cursor by 1 day
#### **org_decrease_date**
*mapped to*: `<C-x>`
Decrease date under cursor by 1 day
#### **org_change_date**
*mapped to*: `cid`
Change date under cursor. Opens calendar to select new date
#### **org_todo**
*mapped to*: `cit`
Cycle todo keyword forward on current headline  ()
#### **org_todo_prev**
*mapped to*: `ciT`
Cycle todo keyword forward on current headline  ()
#### **org_toggle_checkbox**
*mapped to*: `<C-Space>`
Toggle current line checkbox state
#### **org_cycle**
*mapped to*: `<TAB>`
Cycle folding for current headline
#### **org_global_cycle**
*mapped to*: `<S-TAB>`
Cycle global folding
#### **org_archive_subtree**
*mapped to*: `<Leader>o$`
Archive current headline to archive location
#### **org_set_tags_command**
*mapped to*: `<Leader>ot`
Set tags on current headline
#### **org_toggle_archive_tag**
*mapped to*: `<Leader>oA`
Toggle "ARCHIVE" tag on current headline
#### **org_do_promote**
*mapped to*: `<<`
Promote headline
#### **org_do_demote**
*mapped to*: `>>`
Demote headline
#### **org_meta_return**
*mapped to*: `<Leader><CR>`
Add headline, list item or checkbox below, depending on current line
#### **org_insert_heading_respect_content**
*mapped to*: `<Leader>oih`
Add headline after current headline + it's content with same level
#### **org_insert_todo_heading**
*mapped to*: `<Leader>oiT`
Add TODO headline right after the current headline
#### **org_insert_todo_heading_respect_content**
*mapped to*: `<Leader>oit`
Add TODO headliner after current headline + it's content
#### **org_move_subtree_up**
*mapped to*: `<Leader>oK`
Move current headline + it's content up by one headline
#### **org_move_subtree_down**
*mapped to*: `<Leader>oJ`
Move current headline + it's content down by one headline