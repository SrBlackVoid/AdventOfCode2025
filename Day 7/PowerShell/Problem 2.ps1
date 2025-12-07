using namespace System.Collections.Generic

#Avg. runtime: ~ 80-100 ms
function SolveProblem2 {
	[CmdletBinding()]
	[OutputType([int])]
	param([string]$InputPath)

	$inputData = Get-Content -Path $InputPath
	$workableData = $inputData -split "`n"

	Write-Verbose "Initializing beam coordinate tracking"
	$beamCoords = [HashSet[int]]::New()
	$beamPaths = @{}
	$startingCoord = $workableData[0].IndexOf("S")
	Write-Debug "Starting index: $startingCoord"
	$beamCoords.Add($startingCoord) | Out-Null
	$beamPaths[$startingCoord] = 1

	Write-Verbose "Running beam through manifold"
	foreach ($line in $workableData[1..($workableData.Count - 1)]) {
		$coordsToCheck = [HashSet[int]]::new($beamCoords,$beamCoords.Comparer)
		foreach ($coord in $coordsToCheck) {
			if ($line[$coord] -eq "^") {
				Write-Verbose "Splitter hit at coordinate $coord"
				$beamCoords.Remove($coord) | Out-Null
				$beamCoords.Add($coord+1) | Out-Null
				$beamCoords.Add($coord-1) | Out-Null

				Write-Verbose "Updating path list"
				$beamPaths[$coord-1] = ($beamPaths[$coord-1] ?? 0) + $beamPaths[$coord]
				$beamPaths[$coord+1] = ($beamPaths[$coord+1] ?? 0) + $beamPaths[$coord]
				$beamPaths[$coord] = 0
			}
		}
	}

	return ($beamPaths.Values | Measure-Object -Sum).Sum
}
