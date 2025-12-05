function GetPaperRollCoordinates {
	[CmdletBinding()]
	param($Map)

	$rollCoordinates = New-Object -Type System.Collections.Generic.HashSet[string]

	$mapCopy = $Map -split "`n"

	for ($i = 0; $i -lt $mapCopy.Count; $i++) {
		$spotParams = @{
			InputObject = $mapCopy[$i]
			Pattern = "@"
			AllMatches = $true
		}
		$rolls = Select-String @spotParams

		foreach ($roll in $rolls.Matches) {
			$rollCoordinates.Add("$i,$($roll.Index)") | Out-Null
		}
	}

	return $rollCoordinates
}

function GetAdjacentCoordinates {
	[CmdletBinding()]
	param(
		[string]$Coordinate,
		[ref]$MapHeight,
		[ref]$MapWidth
	)

	$x = ($Coordinate -split ",")[0] -as [int]
	$y = ($Coordinate -split ",")[1] -as [int]

	Write-Verbose "Getting adjacent coordinates for $Coordinate"
	$adjCoordinates = @( #deliberately making it look like a 3x3 map
		"$($x-1),$($y-1)","$($x-1),$y","$($x-1),$($y+1)",
		"$x,$($y-1)",				   "$x,$($y+1)",
		"$($x+1),$($y-1)","$($x+1),$y","$($x+1),$($y+1)"
	)
	Write-Debug "Adjacency candidates for $Coordinate`: $adjCoordinates"

	$results = $adjCoordinates | Where-Object {
		$adjRow = ($_ -split ",")[0] -as [int]
		Write-Debug "AdjCoord Row: $adjRow"
		$adjCol = ($_ -split ",")[1] -as [int]
		Write-Debug "AdjCoord Col: $adjCol"
		($adjRow -ne -1 -and $adjCol -ne -1 -and
		$adjRow -lt $MapHeight.Value -and $adjCol -lt $MapWidth.Value)
	}
	Write-Debug "Validated adjacent coordinates: $results"
	if (!$results) {
		Write-Error "No valid adjacent coordinates for $Coordinate (?)"
	}

	return $results
}

function SolveProblem1 {
	[CmdletBinding()]
	[OutputType([int])]
	param([string]$InputPath)

	$inputData = Get-Content -Path $InputPath

	$rollCoordinates = GetPaperRollCoordinates -Map $inputData
	$mapHeight = $inputData.Count
	$mapWidth = $inputData[0].Length

	$answer = 0
	foreach ($coord in $rollCoordinates) {
		$adjacentCoordParams = @{
			Coordinate = $coord
			MapHeight = [ref]$mapHeight
			MapWidth  = [ref]$mapWidth
		}
		$adjacentCoords = GetAdjacentCoordinates @adjacentCoordParams

		$adjacentRolls = $adjacentCoords | Where-Object {
			$rollCoordinates.Contains($_)
		}
		Write-Debug "Adjacent roll coordinates: $adjacentRolls"
		if ($adjacentRolls.Count -lt 4) {
			$answer++
		}
	}

	return $answer
}
