Title ""

Controls {
}

IOControls {
	outputFile = "nmos1"
	EnableSections
}

Definitions {
	Constant "ConstantProfileDefinition.substrate" {
		Species = "BoronActiveConcentration"
		Value = 1e+17
	}
	Constant "ConstantProfileDefinition.source" {
		Species = "PhosphorusActiveConcentration"
		Value = 1e+20
	}
	Constant "ConstantProfileDefinition.drain" {
		Species = "PhosphorusActiveConcentration"
		Value = 1e+20
	}
	Refinement "RefinementDefinition.all" {
		MaxElementSize = ( 0.02 0.02 )
		MinElementSize = ( 0.01 0.01 )
	}
	Multibox "MultiboxDefinition_1"
	{
		MaxElementSize = ( 0.01 0.01 )
		MinElementSize = ( 0.005 0.005 )
		Ratio = ( 1 1.35 )
	}
}

Placements {
	Constant "ConstantProfilePlacement.substrate" {
		Reference = "ConstantProfileDefinition.substrate"
		EvaluateWindow {
			Element = region ["region_1_substrate"]
		}
	}
	Constant "ConstantProfilePlacement.source" {
		Reference = "ConstantProfileDefinition.source"
		EvaluateWindow {
			Element = region ["region_2_source"]
		}
	}
	Constant "ConstantProfilePlacement.drain" {
		Reference = "ConstantProfileDefinition.drain"
		EvaluateWindow {
			Element = region ["region_3_drain"]
		}
	}
	Multibox "MultiboxPlacement.channel" {
		Reference = "MultiboxDefinition_1"
		RefineWindow = Rectangle [(0.15 -0.005) (1.25 0.1)]
	}
}

