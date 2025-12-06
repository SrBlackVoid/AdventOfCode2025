function SolveProblem1 {
	[CmdletBinding()]
	[OutputType([int])]
	param([string]$InputPath)

	$inputData = Get-Content -Path $InputPath
	$workableData = $inputData -split "`n"

	$operands = $workableData[-1].Trim() -split "\s+"

	$answer = $workableData[0].Trim() -split "\s+"

	foreach ($line in 1..($workableData.Count - 2)) {
		$lineNumbers = $workableData[$line].Trim() -split "\s+"
		Write-Debug "Line numbers: $($lineNumbers -join ', ')"
		foreach ($entry in 0..($lineNumbers.Count - 1)) {
			$mathProblem = "$($answer[$entry]) $($operands[$entry]) $($lineNumbers[$entry])"
			Write-Verbose "Executing: $mathProblem"
			$scriptBlock = [scriptblock]::Create($mathProblem)
			$answer[$entry] = & $scriptBlock
			Write-Debug "$mathProblem = $($answer[$entry])"
		}
		Write-Debug "Answers at this stage: $($answer -join ', ')"
	}

	return ($answer | Measure-Object -Sum).Sum
}
