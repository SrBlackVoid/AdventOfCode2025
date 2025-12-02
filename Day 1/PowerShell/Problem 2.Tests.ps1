Describe "TurnDial" {
	BeforeAll {
		. ".\Problem 2.ps1"
	}

	It "Should throw if not given a valid left-right direction" {
		$testCurrent = 50
		$testDirections = "X120"

		{ TurnDial $testCurrent $testDirections } |
			Should -Throw -ExpectedMessage "Invalid direction format"
	}

	Context "Dial Position" {
		It "Should throw if not given any number after the direction" {
			$testCurrent = 50
			$testDirections = "L"

			{ TurnDial $testCurrent $testDirections } |
				Should -Throw -ExpectedMessage "Invalid direction format"
		}

		It "Should go down in numbers when turning left" {
			$testCurrent = 50
			$testDirections = "L5"

			$results = TurnDial $testCurrent $testDirections

			$results.Position | Should -Be 45
		}

		It "Should go up in numbers when turning right" {
			$testCurrent = 50
			$testDirections = "R5"

			$results = TurnDial $testCurrent $testDirections

			$results.Position | Should -Be 55
		}

		It "Should wrap around to 99 if turned past 0 going left" {
			$testCurrent = 10
			$testDirections = "L20"

			$results = TurnDial $testCurrent $testDirections

			$results.Position | Should -Be 90
		}

		It "Should wrap around to 0 if turned past 99 going right" {
			$testCurrent = 90
			$testDirections = "R20"

			$results = TurnDial $testCurrent $testDirections

			$results.Position | Should -Be 10
		}

		It "Should wrap left on multiple full dial twists" {
			$testCurrent = 10
			$testDirections = "L220"

			$results = TurnDial $testCurrent $testDirections

			$results.Position | Should -Be 90
		}

		It "Should wrap right on multiple full dial twists" {
			$testCurrent = 90
			$testDirections = "R220"

			$results = TurnDial $testCurrent $testDirections

			$results.Position | Should -Be 10
		}
	}

	Context "Counting Clicks" {
		Context "Wrapping around" {
			It "Should count a click when going past 0 going left" {
				$testCurrent = 10
				$testDirections = "L20"

				$results = TurnDial $testCurrent $testDirections

				$results.Clicks | Should -Be 1
			}

			It "Should count a click when going past 99 going right" {
				$testCurrent = 90
				$testDirections = "R20"

				$results = TurnDial $testCurrent $testDirections

				$results.Clicks | Should -Be 1
			}
		}

		Context "Landing on zero" {
			It "Should count a click when landing on 0 going left" {
				$testCurrent = 10
				$testDirections = "L10"

				$results = TurnDial $testCurrent $testDirections

				$results.Clicks | Should -Be 1
			}

			It "Should count a click when landing on 0 going right" {
				$testCurrent = 90
				$testDirections = "R10"

				$results = TurnDial $testCurrent $testDirections

				$results.Clicks | Should -Be 1
			}
		}

		Context "Starting on zero" {
			It "Should not count a click when STARTING at 0 going left" {
				$testCurrent = 0
				$testDirections = "L10"

				$results = TurnDial $testCurrent $testDirections

				$results.Clicks | Should -Be 0
			}

			It "Should not count a click when STARTING at 0 going right" {
				$testCurrent = 0
				$testDirections = "R10"

				$results = TurnDial $testCurrent $testDirections

				$results.Clicks | Should -Be 0
			}
		}

		Context "Multiple full dial twists" {
			It "Should count 3 clicks when going right 3 full times starting on zero" {
				$testCurrent = 0
				$testDirections = "R300"

				$results = TurnDial $testCurrent $testDirections

				$results.Clicks | Should -Be 3
			}

			It "Should count two clicks when going left 2 full times starting on zero" {
				$testCurrent = 0
				$testDirections = "L200"

				$results = TurnDial $testCurrent $testDirections

				$results.Clicks | Should -Be 2
			}

			It "Should count 2 clicks when starting mid-dial and landing on zero the 2nd wrap-around going left" {
				$testCurrent = 20
				$testDirections = "L120"

				$results = TurnDial $testCurrent $testDirections

				$results.Clicks | Should -Be 2
			}

			It "Should count 2 clicks when starting mid-dial and landing on zero the 2nd wrap-around going right" {
				$testCurrent = 80
				$testDirections = "R120"

				$results = TurnDial $testCurrent $testDirections

				$results.Clicks | Should -Be 2
			}
			
			It "Should count 4 clicks going 4 full dial twists left (not starting or landing on zero)" {
				$testCurrent = 50
				$testDirections = "L400"

				$results = TurnDial $testCurrent $testDirections

				$results.Clicks | Should -Be 4
			}

			It "Should count 4 clicks going 4 full dial twists right (not starting or landing on zero)" {
				$testCurrent = 50
				$testDirections = "R400"

				$results = TurnDial $testCurrent $testDirections

				$results.Clicks | Should -Be 4
			}
		}
	}
}

Describe "SolveProblem2" {
	BeforeAll {
		$source = ".\Problem 2.ps1"

		. $source
	}

	It "Returns 6 for the demo example" {
		$inputPath = ".\Problem 1 demo inputs.txt"

		$result = SolveProblem2 -InputPath $inputPath

		$result | Should -Be 6
	}

	It "Passes ScriptAnalyzer" {
		$analyzer = Invoke-ScriptAnalyzer -Path $source

		$analyzer | Should -BeNullOrEmpty
	}
}
