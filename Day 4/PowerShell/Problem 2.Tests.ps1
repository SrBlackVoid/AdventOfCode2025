Describe "GetPaperRollCoordinates" {
	BeforeAll {
		. ".\Problem 2.ps1"
	}

	It "Identifies the coordinates of rolls in a basic 3x3 grid" {
		$inputData = @"
.@.
@.@
.@.
"@

		$results = GetPaperRollCoordinates -Map $inputData

		$results | Should -BeExactly @("0,1", "1,0", "1,2", "2,1")
	}

	It "Identifies the coordinates of rolls in a basic 4x4 grid" {
		$inputData = @"
.@.@
@.@.
.@.@
@.@.
"@

		$results = GetPaperRollCoordinates -Map $inputData

		$results | Should -BeExactly @("0,1", "0,3","1,0", "1,2", "2,1", "2,3", "3,0","3,2")
	}

	It "Identifies the coordinates of rolls in a 3x4 grid" {
		$inputData = @"
.@.@
@.@.
.@.@
"@

		$results = GetPaperRollCoordinates -Map $inputData

		$results | Should -BeExactly @("0,1", "0,3","1,0", "1,2", "2,1", "2,3")
	}
}

Describe "GetAdjacentCoordinates" {
	BeforeAll {
		$inputPath = "TestDrive:\testMap.txt"
		. ".\Problem 2.ps1"
		@"
.@.@
@.@.
.@.@
@.@.
"@ | Out-File -Path $inputPath
		$testMap = Get-Content $inputPath
		$mapHeight = ($testMap -split "`n").Count
		$mapWidth = ($testMap -split "`n")[0].Length #Counts endLine as another char for some reason

		$testParams = @{
			Coordinate = $null
			MapHeight = [ref]$mapHeight
			MapWidth  = [ref]$mapWidth
		}
	}

	It "Finds adjacent coordinates for a spot in the middle of the map" {
		$testInput = "2,2"

		$testParams.Coordinate = $testInput
		$results = GetAdjacentCoordinates @testParams

		$expected = @(
			"1,1","1,2","1,3",
			"2,1",		"2,3",
			"3,1","3,2","3,3"
		)

		$results | Should -BeExactly $expected
	}

	It "Does not count spots to the left if on the left edge of map" {
		$testInput = "2,0"

		$testParams.Coordinate = $testInput
		$results = GetAdjacentCoordinates @testParams

		$expected = @(
			"1,0","1,1",
					"2,1",
			"3,0","3,1"
		)

		$results | Should -BeExactly $expected
	}

	It "Does not count spots to the right if on the right side of map" {
		$testInput = "2,3"

		$testParams.Coordinate = $testInput
		$results = GetAdjacentCoordinates @testParams

		$expected = @(
			"1,2","1,3",
			"2,2",		
			"3,2","3,3"
		)

		$results | Should -BeExactly $expected
	}

	It "Does not count spots above if on top of map" {
		$testInput = "0,2"

		$testParams.Coordinate = $testInput
		$results = GetAdjacentCoordinates @testParams

		$expected = @(
			"0,1",		"0,3",
			"1,1","1,2","1,3"
		)

		$results | Should -BeExactly $expected
	}

	It "Does not count spots below if at bottom of map" {
		$testInput = "3,2"

		$testParams.Coordinate = $testInput
		$results = GetAdjacentCoordinates @testParams

		$expected = @(
			"2,1","2,2","2,3",
			"3,1",		"3,3"
		)

		$results | Should -BeExactly $expected
	}
}

Describe "SolveProblem2" {
	BeforeAll {
		$source = ".\Problem 2.ps1"

		. $source
	}

	It "Returns the correct value for the demo example" {
		$inputPath = ".\Demo inputs.txt"

		$result = SolveProblem2 -InputPath $inputPath

		$result | Should -Be 43
	}

	It "Passes ScriptAnalyzer" {
		$analyzer = Invoke-ScriptAnalyzer -Path $source

		$analyzer | Should -BeNullOrEmpty
	}
}
