function SolveProblem2 {
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
	<# $ids = ([Regex]::Matches($inputSections[1],"(\d+)")).Value |
		ForEach-Object { [int64]($_) } |
		Sort-Object #>

	$answer = 0
	$i = 0

	while ($i -lt $ranges.Count) {
		$block = @{
			Start = $ranges[$i].StartIndex
			End = $ranges[$i].EndIndex
		}
		$i++
		while ($ranges[$i].StartIndex -le $block.End -and $i -lt $ranges.Count) {
			Write-Verbose "$($ranges[$i].StartIndex)-$($ranges[$i].EndIndex) overlaps with $($block.Start)-$($block.End), extending block"
			$block.End = [Math]::Max($block.End,$ranges[$i].EndIndex)
			$i++
		} #Until startIndex is greater than block end
		$answer += ($block.End - $block.Start + 1)
	}

	return $answer
}
