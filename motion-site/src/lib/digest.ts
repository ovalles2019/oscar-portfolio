export type DigestSource = {
  title: string;
  outlet: string;
  url: string;
};

export type DigestLatest = {
  weekOf: string;
  title: string;
  takeaways: string[];
  watchNext: string;
  sources?: DigestSource[];
  projectUrl: string;
  updatedAt?: string;
};
