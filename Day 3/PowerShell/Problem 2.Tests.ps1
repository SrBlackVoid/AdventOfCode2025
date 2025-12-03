Describe "GetJoltage" {
	BeforeAll {
		. ".\Problem 2.ps1"
	}

	Context "Demo examples" {
		It "Works when fed in 987654321111111" {
			$testInput = "987654321111111"

			$result = GetJoltage -BatteryBank $testInput

			$result | Should -Be 987654321111
		}

		It "Works when fed in 811111111111119" {
			$testInput = "811111111111119"

			$result = GetJoltage -BatteryBank $testInput

			$result | Should -Be 811111111119
		}

		It "Works when fed in 234234234234278" {
			$testInput = "234234234234278"

			$result = GetJoltage -BatteryBank $testInput

			$result | Should -Be 434234234278
		}

		It "Works when fed in 818181911112111" {
			$testInput = "818181911112111"

			$result = GetJoltage -BatteryBank $testInput

			$result | Should -Be 888911112111
		}
	}
}

Describe "SolveProblem1" {
	BeforeAll {
		$source = ".\Problem 2.ps1"

		. $source
	}

	It "Returns the correct value for the demo example" {
		$inputPath = ".\Demo inputs.txt"

		$result = SolveProblem2 -InputPath $inputPath

		$result | Should -Be 3121910778619
	}

	It "Passes ScriptAnalyzer" {
		$analyzer = Invoke-ScriptAnalyzer -Path $source

		$analyzer | Should -BeNullOrEmpty
	}
}
