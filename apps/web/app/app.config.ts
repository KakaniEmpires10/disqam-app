export default defineAppConfig({
  ui: {
    colors: {
      primary: 'disqam',
      secondary: 'cyan',
      neutral: 'slate'
    },
    button: {
      slots: {
        base: 'cursor-pointer'
      },
      defaultVariants: { size: 'lg' }
    },
    input: {
      slots: {
        root: 'w-full',
        base: 'min-h-12 rounded-xl text-lg focus:outline-none focus-visible:outline-3 focus-visible:outline-primary focus-visible:ring-primary'
      },
      defaultVariants: { size: 'lg', variant: 'outline' }
    },
    skeleton: {
      base: 'animate-pulse rounded-md bg-primary/20'
    }
  }
})
