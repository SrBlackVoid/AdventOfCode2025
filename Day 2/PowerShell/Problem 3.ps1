function GetInvalidIDs {
	[CmdletBinding()]
	[OutputType([System.Object[]])]
	param(
		$StartIndex,
		$EndIndex
	)

	$startIndexLength = $startIndex.ToString().Length
	$endIndexLength = $endIndex.ToString().Length

	if (-NOT ($startIndexLength..$endIndexLength) | Where-Object {
		$_ % 2 -eq 0
	}) {
		return $null #Can't have odd-lengthed invalid IDs
	}

	$invalidIDs = @()

	for ($i = $StartIndex; $i -le $EndIndex; $i++) {
		if ($i.ToString() -match  "^(\d+)(?=\1$)") {
			$invalidIDs += $i
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
