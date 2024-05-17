const caches = new Map();

export const init = (cacheNames) => {
  cacheNames.toArray().forEach((name) => {
    if (!caches.has(name)) {
      caches.set(name, new Map());
    }
  });
};

export const memo = (arg, cacheName, fun) => {
  const cache = getCache(cacheName);
  const resp = cache.get(arg);
  if (resp) {
    return resp;
  } else {
    const resp = fun(arg);
    cache.set(arg, resp);
    return resp;
  }
};

export const invalidateAll = (cacheName) => {
  const cache = getCache(cacheName);
  cache.clear();
};

export const invalidateSpecific = (arg, cacheName) => {
  const cache = getCache(cacheName);
  cache.delete(arg);
};

const getCache = (cacheName) => {
  const cache = caches.get(cacheName);
  if (!cache) {
    throw new Error(`Cache not initialized "${cacheName}"`);
  }
  return cache;
};

export const cleanUp = () => caches.clear();
