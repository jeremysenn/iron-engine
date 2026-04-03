# IronEngine

  Fitness coaching platform encoding the Kilo Strength Society methodology as a
  deterministic rule engine with an LLM coaching explanation layer.

  ## Design Doc
  The full design specification is at docs/DESIGN.md. Read it before starting any
  implementation work.

  ## KILO Reference Materials
  The source PDFs for the KILO methodology are at:
  /Users/jeremysenn/Documents/Kilo Strength Society/

  Key documents:
  - Program Design Course/ProgramDesignResource.pdf
  - Periodization Course/KILOOnlinePeriodizationResource.pdf
  - Optimizing Strength Ratios Course/OptimizingStrengthRatiosResource.pdf
  - Optimizing Strength Ratios Course/Examples/Beginner
  - Optimizing Strength Ratios Course/Examples/Intermediate
  - Optimizing Strength Ratios Course/Examples/Advanced
  - Stars and Stripes/Stars & Stripes - Chest & Back
  - Stars and Stripes/Stars & Stripes - Arms & Shoulders
  - Stars and Stripes/Stars & Stripes - Lower Body
  - Short Term Macros/3-Week Wave Loading Program.pdf
  - Short Term Macros/Functional Hypertrophy Macrocycle 2.pdf
  - Short Term Macros/Speed-Strength Continuum.pdf
  - Fat Loss Program Design/FatLossProgramDesignResource-230208-124303
  - MAP Assessment/MAP Assessment Resource.pdf
  - KILO Training Split Database.pdf
  - Long-Term Periodization Database.pdf
  - KILO Rep Schemes Database.pdf
  - KILO Exercise Database.pdf

  ## Design System
  Always read DESIGN.md before making any visual or UI decisions.
  All font choices, colors, spacing, and aesthetic direction are defined there.
  Do not deviate without explicit user approval.
  In QA mode, flag any code that doesn't match DESIGN.md.

  ## Skill routing

  When the user's request matches an available skill, ALWAYS invoke it using the Skill
  tool as your FIRST action. Do NOT answer directly, do NOT use other tools first.

  Key routing rules:
  - Bugs, errors, "why is this broken", 500 errors → invoke investigate
  - Ship, deploy, push, create PR → invoke ship
  - QA, test the site, find bugs → invoke qa
  - Code review, check my diff → invoke review
