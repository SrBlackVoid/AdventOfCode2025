using namespace System.Collections.Generic

function CalculateArea {
	[CmdletBinding()]
	[OutputType([int])]
	param(
		$Coord1,
		$Coord2
	)

	return (([Math]::Abs($Coord1[0] - $Coord2[0])+1) * ([Math]::Abs($Coord1[1] - $Coord2[1])+1))
}

function SolveProblem1 {
<#
	STRATEGY: Semi-brute force checking all possible coordinate combinations.
	Avg. runtime:  ~ 4 seconds
#>
	[CmdletBinding()]
	[OutputType([int])]
	param(
		[Parameter(Mandatory)]
		[string]$InputPath
	)

	$inputData = Get-Content -Path $InputPath
	$pointCoords = [List[int[]]]::new()

	[int64]$answer = 0
	for ($i = 0; $i -lt $inputData.Count; $i++) {
		$line = $inputData[$i]
		Write-Verbose "Processing line: $line"
		$currentCoords = $line -split ","
		for ($j = 0; $j -lt $pointCoords.Count; $j++) {
			$comparePoint = $pointCoords[$j]
			$area = CalculateArea -Coord1 $currentCoords -Coord2 $comparePoint
			Write-Debug "Area from $($currentCoords -join "-") to $($comparePoint -join "-"): $area"
			$answer = [Math]::Max($answer,$area)
		}

		$pointCoords.Add($currentCoords) | Out-Null
	}

	return $answer
}
