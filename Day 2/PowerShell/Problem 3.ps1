function GetInvalidIDs {
	[CmdletBinding()]
	[OutputType([System.Collections.Generic.List[int64]])]
	param(
		$StartIndex,
		$EndIndex
	)

	$startIndexLength = $startIndex.ToString().Length
	$endIndexLength = $endIndex.ToString().Length

	$evenIndexLengths = $startIndexLength..$endIndexLength |
		Where-Object { $_ % 2 -eq 0 }

	$invalidIDs = [System.Collections.Generic.List[int64]]::new()
	foreach ($length in $evenIndexLengths) {
		$halfLength = $length / 2

		# Override min if we're at the start boundary
		$minHalf = if ($length -eq $startIndexLength) {
			[int64]$StartIndex.ToString().Substring(0, $halfLength)
		} else { [Math]::Pow(10,$halfLength - 1) }
		if ([int64]"$minHalf$minHalf" -lt $StartIndex) {
			$minHalf++
		}

		$maxHalf = if ($length -eq $endIndexLength) {
			[int64]$EndIndex.ToString().Substring(0, $halfLength)
		} else { [Math]::Pow(10, $halfLength) - 1 }
		if ([int64]"$maxHalf$maxHalf" -gt $EndIndex) {
			$maxHalf--
		}

		Write-Debug ([PSCustomObject]@{
			StartIndex = $StartIndex
			EndIndex = $EndIndex
			Length = $length
			MinHalf = $minHalf
			MaxHalf = $maxHalf
		} | Out-String)
		$invalidIdHalves = $minHalf..$maxHalf

		foreach ($halve in $invalidIdHalves) {
			$candidateID = [int64]"$halve$halve"
			if ($candidateID -ge $StartIndex -and $candidateID -le $EndIndex) {
				$invalidIDs.Add($candidateID)
			}
		}
	}

	return $invalidIDs
}

function GetIDRanges {
	[CmdletBinding()]
	[OutputType([hashtable])]
	param(
		$Range
	)

	if ($Range -notmatch "(\d+)-(\d+)") {
		throw "Invalid range format: $Range"
	}

	$startIndex = [int64]$Matches[1]
	$endIndex = [int64]$Matches[2]

	return @{
		StartIndex = $startIndex
		EndIndex = $endIndex
	}
}

function SolveProblem3 {
	[CmdletBinding()]
	param(
		$InputPath
	)

	$inputData = Get-Content -Path $InputPath

	$ranges = $inputData -split ","
	$answer = 0

	foreach ($entry in $ranges) {
		$indexes = GetIDRanges -Range $entry
		$invalidIDs = GetInvalidIDs -StartIndex $indexes.StartIndex -EndIndex $indexes.EndIndex
		$answer += ($invalidIDs | Measure-Object -Sum).Sum
	}

	return $answer
}
