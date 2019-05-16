function New-Passwd {
<#

.SYNOPSIS
A simple script that generates a random, but human-pronounceable password.

.DESCRIPTION
Version: 2.0
This script creates a random password based on human-pronounceable syllables.
You can adjust the number of syllables, and when working with it interactively,
includes the ability to generate multiple passwords. The generated password
will include a symbol character in a random location, and a 2-4 digit number suffix.

When integrating this function into a script, you'll likely want to use the -HideOutput
switch to prevent the password from being outputted to the console.

.EXAMPLE
New-Passwd

Default generates one password that is four (4) syllables long, 15-17 character length total.

Example output:
PS > Jabgot@darsay8472

.EXAMPLE
New-Passwd -Length 20 -Count 5

Generates 5 passwords that are each 20-syllables long.

Example output:
PS > Neoreonuasantotlenlodjusveitavfihpotretvifruajigvuolua;tiuket6348
PS > Coasuukocfekbestajbacnutbabheptaksegcui.sesnadsotjuncaesojpou7255
PS > Paeruamohsadheimukbanneakui;pujgodmejsuinegjaobitfoffejgafheu2701
PS > Hapdaobagtiecokbihlubkiurubroelephep-munlijdumgemcuspagmuvkub4728
PS > Dejtegbia{gonbimpilpiltavvardiiribdujsevvujfovripdornopjiodoj3586

.EXAMPLE
New-Passwd -HideOutput

Generates one default password that is four (4) syllables long, 15-17 character length total,
and does not show the output. It is useful to include this switch when calling from within
a script where you will be using the $script:Passwd variable elsewhere.
Default is to write output.

Example output:
PS > 

#>
    [cmdletbinding()]
    param(
        [Parameter(Position=0)]
        #Default length in syllables.
        [Int]$Length = 4,
        [Parameter(Position=1)]
        #Default number of passwords to create.
        [Int]$Count = 1,
        [Parameter(Position=2)]
        #Hides the output. useful when used within a script.
        [Switch]$HideOutput
    )
    Begin {
        #consonants except hard to speak ones
        [Char[]]$lowercaseConsonants = "bcdfghjklmnprstv"
        [Char[]]$uppercaseConsonants = "BCDFGHJKLMNPRSTV"
        #vowels
        [Char[]]$lowercaseVowels = "aeiou"
        #both
        $lowercaseConsantsVowels = $lowercaseConsonants+$lowercaseVowels
        #numbers
        [Char[]]$numbers = "0123456789"
        #special characters
        [Char[]]$specialCharacters = '!$.;#@{+&}?:+_="%>-*/^'+"'"

        $countNum = 0
    }
    Process {
        while ($countNum -le $Count-1) {
            $script:Passwd = ''
            #random location for special char between first syllable and length
            $specialCharSpot = Get-Random -Minimum 1 -Maximum $Length
            for ($i=0; $i -lt $Length; $i++) {
                if ($i -eq $specialCharSpot) {
                    #add a special char
                    $script:Passwd += ($specialCharacters | Get-Random -Count 1)
                }
                #Start with uppercase
                if ($i -eq 0) {
                    $script:Passwd += ($uppercaseConsonants | Get-Random -Count 1)
                } else {
                    $script:Passwd += ($lowercaseConsonants | Get-Random -Count 1)
                }
                $script:Passwd += ($lowercaseVowels | Get-Random -Count 1)
                $script:Passwd += ($lowercaseConsantsVowels | Get-Random -Count 1)
            }
            #add a number at the end
            $randNumNum = Get-Random -Minimum 2 -Maximum 5
            $script:Passwd += (($numbers | Get-Random -Count $randNumNum)-join '')
            if ($HideOutput) {
                # The $Passwd is not shown as output.
            } else {
                Write-Output "$script:Passwd"
            }
            $countNum++
        }
    }
}