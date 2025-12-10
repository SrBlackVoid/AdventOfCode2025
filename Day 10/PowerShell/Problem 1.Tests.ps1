Describe "ConvertRowToVectors" {
	BeforeAll {
		. ".\Problem 1.ps1"
	}

	Context "Lights" {
		It "Converts [.##.] to 6" {
			$testInput = "[.##.]"
			$result = ConvertRowToVectors -Data $testInput
			$result.Lights | Should -Be 6
		}

		It "Converts [#.#.] to 10" {
			$testInput = "[#.#.]"
			$result = ConvertRowToVectors -Data $testInput
			$result.Lights | Should -Be 10
		}
		
		It "Converts [..##] to 3" {
			$testInput = "[..##]"
			$result = ConvertRowToVectors -Data $testInput
			$result.Lights | Should -Be 3
		}
	}

	Context "Buttons" {
		Context "Button Values" {
			It "Converts (1,2) to 3 in a 3-light setup" {
				$testInput = "[.##] (1,2)"
				$result = ConvertRowToVectors -Data $testInput
				$result.Buttons | Should -Be 3
			}

			It "Converts (1,2) to 6 in a 4-light setup" {
				$testInput = "[.##.] (1,2)"
				$result = ConvertRowToVectors -Data $testInput
				$result.Buttons | Should -Be 6
			}
		}

		Context "Multiple Buttons Handling" {
			It "Returns an array of buttons" {
				$testInput = "[.##.] (1,2) (0,2)"
				$result = ConvertRowToVectors -Data $testInput
				$result.Buttons | Should -BeExactly @(6,10)
			}
		}
	}
}

Describe "SolveProblem1" {
	BeforeAll {
		$source = ".\Problem 1.ps1"

		. $source
	}

	It "Returns the correct value for the demo example" {
		$inputPath = ".\Demo inputs.txt"

		$result = SolveProblem1 -InputPath $inputPath

		$result | Should -Be 7
	}

	It "Passes ScriptAnalyzer" {
		$analyzer = Invoke-ScriptAnalyzer -Path $source

		$analyzer | Should -BeNullOrEmpty
	}
}
