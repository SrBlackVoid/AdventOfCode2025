function TurnDial {
	[CmdletBinding()]
	[OutputType([Hashtable])]
	param(
		[Parameter(Mandatory)]
		[int]$CurrentPosition,
		[string]$Directions
	)

	if ($Directions -notmatch "([LR])(\d+)") {
		throw "Invalid direction format"
	}

	$direction = ($Matches[1])
	$turnAmount = [int]($Matches[2])
	Write-Debug "Direction: $direction"
	Write-Debug "Turn Amount: $turnAmount"

	$newPosition = ($direction -eq "R") ?
		($CurrentPosition + $turnAmount) :
		($CurrentPosition - $turnAmount)
	Write-Debug "Initial new value: $newPosition"

	$leftClicks = ($CurrentPosition -eq 0 -and $direction -eq "L") ? -1 : 0
	while ($newPosition -lt 0) {
		$newPosition += 100
		$leftClicks++
	}
	if ($newPosition -eq 0) {
		$leftClicks++
	}
	Write-Debug "Clicks counted going left: $leftClicks"

	$rightClicks = [Math]::Truncate($newPosition / 100)
	Write-Debug "Clicks counted going right: $rightClicks"

	$finalPosition = $newPosition % 100
	Write-Debug "Resolved new position: $finalPosition"

	return @{
		Position = $finalPosition
		Clicks = ($leftClicks + $rightClicks)
	}
}

function SolveProblem2 {
	[CmdletBinding()]
	[OutputType([int])]
	param($InputPath)

	$inputData = Get-Content -path $InputPath

	$dialPosition = 50
	$answer = 0

	foreach ($line in $inputData) {
		Write-Verbose "Turning $line from position $dialPosition"
		$turnResults = TurnDial -CurrentPosition $dialPosition -Directions $line
		$dialPosition = $turnResults.Position
		$answer += $turnResults.Clicks
	}

	return $answer
}
