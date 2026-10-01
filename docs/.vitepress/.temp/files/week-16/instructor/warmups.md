# Warm-up and check-yourself answers

### W01

Creation marks every modeled kind live. Block exit ends the modeled automatic object while static/allocated remain. Explicit release ends the modeled allocated object; the static object remains. Real scopes, multiple blocks and process termination require more context, and this function never inspects a pointer. Reject unsupported kinds/events without committing output.

### W02

Guard n>SIZE_MAX/sizeof(int) before multiplying; zero succeeds. Arithmetic representability is different from available memory, successful malloc or a live owner. Preserve the old output on failure, including NULL-output rejection before writing.

### W03

Check out and seed!=INT_MAX before signed addition. An automatic value can be copied into the caller’s live object before the helper ends; no pointer to the helper’s local escapes. INT_MIN+1 is representable. Returning by value would also repair the lifetime issue under another API.

Check yourself: A pointer object and its pointee have separate lifetimes. Scope is name visibility, not duration. A failed allocation preserves old ownership; successful resize invalidates previous borrows. Static mutable state is shared and this API is single-threaded. Diagnostics are evidence for exercised bugs, not a proof of every valid access.
