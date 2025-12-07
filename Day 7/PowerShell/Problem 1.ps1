using namespace System.Collections.Generic

function SolveProblem1 {
	[CmdletBinding()]
	[OutputType([int])]
	param([string]$InputPath)

	$inputData = Get-Content -Path $InputPath
	$workableData = $inputData -split "`n"

	Write-Verbose "Initializing beam coordinate tracking"
	$beamCoords = [HashSet[int]]::New()
	$startingCoord = $workableData[0].IndexOf("S")
	Write-Debug "Starting index: $startingCoord"
	$beamCoords.Add($startingCoord) | Out-Null

	$answer = 0
	Write-Verbose "Running beam through manifold"
	foreach ($line in $workableData[1..($workableData.Count - 1)]) {
		$coordsToCheck = [HashSet[int]]::new($beamCoords,$beamCoords.Comparer)
		foreach ($coord in $coordsToCheck) {
			if ($line[$coord] -eq "^") {
				$beamCoords.Remove($coord) | Out-Null
				$beamCoords.Add($coord+1) | Out-Null
				$beamCoords.Add($coord-1) | Out-Null
				$answer++
			}
		}
	}

	return $answer
}
