import { TinyEmitter } from 'tiny-emitter'

class Emitter {
  private emitter: TinyEmitter

  constructor() {
    this.emitter = new TinyEmitter()
  }

  on(event: string, callback: Function, ctx?: any) {
    this.emitter.on(event, callback, ctx)
  }

  once(event: string, callback: Function, ctx?: any) {
    this.emitter.once(event, callback, ctx)
  }

  emit(event: string, ...args: any[]) {
    this.emitter.emit(event, ...args)
  }

  off(event: string, callback?: Function) {
    this.emitter.off(event, callback)
  }
}

export const eventHub = new Emitter()
