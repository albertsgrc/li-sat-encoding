fs = require 'fs'
util = require 'util'

error = (msg) ->
    console.error msg
    process.exit 1

file = fs.readdirSync('.').filter((s) -> s.match(/^.*\.pl$/))[0]
c = fs.readFileSync(file, { encoding: 'utf-8' })

functionBegin = "writeClauses:-\n"
functionEnd = "true."

writingIndex = c.indexOf(functionEnd) + functionEnd.length

restrictions = c[c.indexOf(functionBegin)+functionBegin.length..]
restrictions = restrictions[...restrictions.indexOf(functionEnd)].trim()
restrictions = restrictions[...-1].split(/,\s*/)

if restrictions.length and c.indexOf("#{restrictions[0]} :-") >= 0
    console.log "Already written motherfucker!"
    process.exit(1)

string = "\n"

for restriction in restrictions
    string +=
        """
            #{restriction} :-

                fail.

            #{restriction}.
            \n\n\n
        """

string = string[...-2]

c = c[..writingIndex] + string + c[writingIndex+1..]

fs.writeFileSync(file, c, 'utf-8')
