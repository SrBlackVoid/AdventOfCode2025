function SolveProblem1 {
	[CmdletBinding()]
	[OutputType([int])]
	param([string]$InputPath)

	$inputData = Get-Content -Path $InputPath -Raw
	$inputSections = $inputData -split "\r?\n\r?\n"

	$ranges = [Regex]::Matches($inputSections[0],"(\d+)-(\d+)") | ForEach-Object {
		[PSCustomObject]@{
			StartIndex = [int64]$_.Groups[1].Value
			EndIndex = [int64]$_.Groups[2].Value
		}
	} | Sort-Object StartIndex,EndIndex
	$ids = ([Regex]::Matches($inputSections[1],"(\d+)")).Value |
		ForEach-Object { [int64]($_) } |
		Sort-Object

	$answer = 0
	$rangeIndex = 0

	:idLoop foreach ($id in $ids) {
		Write-Verbose "Assessing ID $id"
		if ($id -lt $ranges[$rangeIndex].StartIndex) {
			Write-Debug "$id less than $($ranges[$rangeIndex].StartIndex),continuing"
			continue
		}
		while ($id -gt $ranges[$rangeIndex].EndIndex) {
			$rangeIndex++
			Write-Debug "Shifting range checker to $($ranges[$rangeIndex].StartIndex)-$($ranges[$rangeIndex].EndIndex)"
			if ($rangeIndex -ge $ranges.Count) {
				break :idLoop
			}
		} # By this point, $id HAS to be <= EndIndex

		if ($id -ge $ranges[$rangeIndex].StartIndex -and
			$id -le $ranges[$rangeIndex].EndIndex) {
			Write-Verbose "$id is good!"
			$answer++
		}
	}

	return $answer
}
