import spa from './spa'

spa.bind.all()

setTimeout(() => {
  const el = document.querySelector('#filled-animate')
  const targetHeight = el.getAttribute('data-height')
  el.style.height = `${targetHeight}%`
}, 500)
