function TurnDial {
	[CmdletBinding()]
	[OutputType([int])]
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

	while ($newPosition -lt 0) {
		$newPosition += 100
	}
	$finalPosition = $newPosition % 100
	Write-Debug "Resolved new position: $finalPosition"

	return $finalPosition
}

function SolveProblem1 {
	[CmdletBinding()]
	[OutputType([int])]
	param($InputPath)

	$inputData = Get-Content -path $InputPath

	$dialPosition = 50
	$answer = 0

	foreach ($line in $inputData) {
		Write-Verbose "Turning $line from position $dialPosition"
		$dialPosition = TurnDial -CurrentPosition $dialPosition -Directions $line
		if ($dialPosition -eq 0) {
			Write-Verbose "Adding 1 to answer"
			$answer++
		}
	}

	return $answer
}
