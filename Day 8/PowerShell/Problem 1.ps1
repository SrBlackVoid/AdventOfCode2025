using namespace System.Collections.Generic

function Get3dDistance {
	# Just uses Euclidean 3D distance formula.
	# Omits the overall sqrt function (don't strictly need it).
	[CmdletBinding()]
	param(
		$Coord1,
		$Coord2
	)

	return (
		[math]::Pow(($Coord2[0] - $Coord1[0]), 2) +
		[math]::Pow(($Coord2[1] - $Coord1[1]), 2) +
		[math]::Pow(($Coord2[2] - $Coord1[2]), 2)
	)
}

function MeasureCircuit {
	[CmdletBinding()]
	[OutputType([int])]
	#Runs a BFS from the StartNode through the NeighborList.
	param([string]$StartNode,
		[HashTable]$NeighborList,
		[HashSet[string]]$CheckedNodes
	)

	$queue = [Queue[string]]::new()
	$circuitList = [HashSet[string]]::new()

	$queue.Enqueue($StartNode)
	$CheckedNodes.Add($StartNode) | Out-Null
	$circuitList.Add($StartNode) | Out-Null
	Write-Verbose "Traversing from junction $StartNode"

	while ($queue.Count -gt 0) {
		$currentNode = $queue.Dequeue()

		foreach ($neighbor in $NeighborList[$currentNode]) {
			if (-NOT $CheckedNodes.Contains($neighbor)) {
				$CheckedNodes.Add($neighbor) | Out-Null
				$queue.Enqueue($neighbor)
				$circuitList.Add($neighbor) | Out-Null
			}
		}
	}

	return $circuitList.Count
}

#Avg. runtime:  ~ 23 seconds
function SolveProblem1 {
	[CmdletBinding()]
	[OutputType([int])]
	param(
		[Parameter(Mandatory)]
		[string]$InputPath,

		[Parameter(Mandatory)]
		[int]$Connections
	)

	$inputData = Get-Content -Path $InputPath
	$pointCoords = [List[int[]]]::new()
	$pointDistances = [SortedList[int64,string]]::new()

	for ($i = 0; $i -lt $inputData.count; $i++) {
		$line = $inputData[$i]
		Write-Verbose "Processing line: $line"
		$currentCoords = $line -split "," | ForEach-Object { [int]$_ }

		Write-Verbose "Calculating distance between points gathered thus far"
		for ($j = 0; $j -lt $pointCoords.Count; $j++) {
			$comparePoint = $pointCoords[$j]
			$distance = Get3dDistance -Coord1 $currentCoords -Coord2 $comparePoint
			Write-Debug "Distance from $($currentCoords -join "-") to $($comparePoint -join "-"): $distance"

			if ($pointDistances.Count -lt $Connections) {
				Write-Verbose "Adding $i-$j distance to list"
				$pointDistances.Add($distance, "$i-$j") | Out-Null
			} else {
				if ($distance -lt $pointDistances.GetKeyAtIndex($Connections - 1)) {
					Write-Verbose "Adding $i-$j distance to list, removing largest entry"
					$pointDistances.RemoveAt($Connections - 1) | Out-Null
					$pointDistances.Add($distance, "$i-$j") | Out-Null
				}
			}
		}

		Write-Verbose "Adding coordinates to Full Coordinate List"
		$pointCoords.Add($currentCoords) | Out-Null
	}

	Write-Verbose "Shortest connections ID'd, mapping neighboring junctions"
	$neighborList = @{}
	foreach ($entry in $pointDistances.Values) {
		$split = $entry -split "-"
		$a = $split[0]
		$b = $split[1]

		if (-NOT $neighborList.ContainsKey($a)) {
			$neighborList[$a] = [List[string]]::new()
		}
		if (-NOT $neighborList.ContainsKey($b)) {
			$neighborList[$b] = [List[string]]::new()
		}

		$neighborList[$a].Add($b)
		$neighborList[$b].Add($a)
	}

	Write-Verbose "Measuring circuits"
	$checkedNodes = [HashSet[string]]::new()
	$longestCircuits = [List[int]]::new()
	$neighborList.GetEnumerator() | ForEach-Object {
		if (-NOT $checkedNodes.Contains($_.Key)) {
			$circuitSize = MeasureCircuit -StartNode $_.Key -NeighborList $neighborList -checkedNodes $checkedNodes
			Write-Debug "Circuit length: $circuitSize"
			if ($longestCircuits.Count -lt 3) {
				$longestCircuits.Add($circuitSize) | Out-Null
			} else {
				if (($longestCircuits | Measure-Object -Minimum).Minimum -lt $circuitSize) {
					$longestCircuits.Remove(($longestCircuits | Measure-Object -Minimum).Minimum) | Out-Null
					$longestCircuits.Add($circuitSize) | Out-Null
				}
			}
		}
	}

	return ($longestCircuits[0] * $longestCircuits[1] * $longestCircuits[2])
}
