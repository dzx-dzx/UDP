ThisBuild / version      := "1.0"
ThisBuild / scalaVersion := "2.11.12"
ThisBuild / organization := "org.example"

val spinalVersion = "dev"
val spinalCore    = "com.github.spinalhdl" %% "spinalhdl-core" % spinalVersion
val spinalLib     = "com.github.spinalhdl" %% "spinalhdl-lib"  % spinalVersion
val spinalIdslPlugin = compilerPlugin(
  "com.github.spinalhdl" %% "spinalhdl-idsl-plugin" % spinalVersion
)

lazy val udp = (project in file("."))
  .settings(
    name := "UDP",
    libraryDependencies ++= Seq(
      "org.scalactic" %% "scalactic" % "3.2.13",
      "org.scalatest" %% "scalatest" % "3.2.13" % "test",
      spinalCore,
      spinalLib,
      spinalIdslPlugin
    )/*,
    scalacOptions := Seq(
      // "-V", // Print a synopsis of verbose options.
      // "-W", // Print a synopsis of warning options.
      // "-X", // Print a synopsis of advanced options.
      // "-Y", // Print a synopsis of private options.

      "-deprecation", // Emit warning and location for usages of deprecated APIs.
      "-encoding",
      "utf-8",                 // Specify character encoding used by source files.
      "-explaintypes", // Explain type errors in more detail.
      "-feature", // Emit warning and location for usages of features that should be imported explicitly.
      "-language:existentials", // Existential types (besides wildcard types) can be written and inferred
      "-language:reflectiveCalls",
      // "-language:experimental.macros",     // Allow macro definition (besides implementation and application)
      // "-language:higherKinds",             // Allow higher-kinded types
      // "-language:implicitConversions",     // Allow definition of implicit functions called views
      "-unchecked", // Enable additional warnings where generated code depends on assumptions.
      "-Xcheckinit", // Wrap field accessors to throw an exception on uninitialized access.
      "-Xfatal-warnings", // Fail the compilation if there are any warnings.
      // "-Xdev",                             // Indicates user is a developer - issue warnings about anything which seems amiss.
      "-Xverify", // Verify generic signatures in generated bytecode.
      // "-Xplugin-list",                    // Print a synopsis of loaded plugins. [false]

      "-Wconf:any:warning-verbose", // Configure reporting of compiler warnings; use `help` for details.
      // "-Wdead-code",                    // Warn when dead code is identified. [false]
      "-Werror", // Fail the compilation if there are any warnings. [false]
      "-Wextra-implicit", // Warn when more than one implicit parameter section is defined. [false]
      "-Wmacros:both", // Inspect both user-written code and expanded trees when generating unused symbol warnings.
      "-Wnumeric-widen",       // Warn when numerics are widened. [false]
      "-Woctal-literal",       // Warn on obsolete octal syntax. [false]
      "-Wunused:imports",     // Warn if an import selector is not referenced.
      "-Wunused:patvars",     // Warn if a variable bound in a pattern is unused.
      "-Wunused:privates",   // Warn if a private member is unused.
      "-Wunused:locals",       // Warn if a local definition is unused.
      "-Wunused:explicits", // Warn if an explicit parameter is unused.
      "-Wunused:implicits", // Warn if an implicit parameter is unused.
      "-Wunused:synthetics", // Warn if a synthetic implicit parameter (context bound) is unused.
      "-Wunused:nowarn", // Warn if a @nowarn annotation does not suppress any warnings.
      "-Wunused:params", // Enable -Wunused:explicits,implicits,synthetics.
      "-Wunused:linted", // -Xlint:unused.
      // "-Wvalue-discard",                // Warn when non-Unit expression results are unused. [false]
      "-Xlint:adapted-args", // An argument list was modified to match the receiver.
      "-Xlint:nullary-unit", // `def f: Unit` looks like an accessor; add parens to look side-effecting.
      "-Xlint:inaccessible", // Warn about inaccessible types in method signatures.
      "-Xlint:infer-any", // A type argument was inferred as Any.
      "-Xlint:missing-interpolator", // A string literal appears to be missing an interpolator id.
      "-Xlint:doc-detached", // When running scaladoc, warn if a doc comment is discarded.
      "-Xlint:private-shadow", // A private field (or class parameter) shadows a superclass field.
      "-Xlint:type-parameter-shadow", // A local type parameter shadows a type already in scope.
      "-Xlint:poly-implicit-overload", // Parameterized overloaded implicit methods are not visible as view bounds.
      "-Xlint:option-implicit",       // Option.apply used an implicit view.
      "-Xlint:delayedinit-select", // Selecting member of DelayedInit.
      "-Xlint:package-object-classes", // Class or object defined in package object.
      "-Xlint:stars-align", // In a pattern, a sequence wildcard `_*` should match all of a repeated parameter.
      "-Xlint:strict-unsealed-patmat", // Pattern match on an unsealed class without a catch-all.
      "-Xlint:constant", // Evaluation of a constant arithmetic expression resulted in an error.
      "-Xlint:unused", // Enable -Wunused:imports,privates,locals,implicits,nowarn.
      "-Xlint:nonlocal-return", // A return statement used an exception for flow control.
      "-Xlint:implicit-not-found", // Check @implicitNotFound and @implicitAmbiguous messages.
      "-Xlint:serial", // @SerialVersionUID on traits and non-serializable classes.
      "-Xlint:valpattern", // Enable pattern checks in val definitions.
      "-Xlint:eta-zero", // Usage `f` of parameterless `def f()` resulted in eta-expansion, not empty application `f()`.
      "-Xlint:eta-sam", // The Java-defined target interface for eta-expansion was not annotated @FunctionalInterface.
      "-Xlint:deprecation", // Enable -deprecation and also check @deprecated annotations.
      "-Xlint:byname-implicit", // Block adapted by implicit with by-name parameter.
      "-Xlint:recurse-with-default", // Recursive call used default argument.
      "-Xlint:unit-special", // Warn for specialization of Unit in parameter position.
      "-Xlint:multiarg-infix", // Infix operator was defined or used with multiarg operand.
      "-Xlint:implicit-recursion" // Implicit resolves to an enclosing definition.
    )*/
  )

fork := true
